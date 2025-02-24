//
//  ViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 23.09.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage" // Идентификатор для перехода к сингл контроллеру
    
    var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
    let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private lazy var dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let token = oauth2TokenStorage.token else { return }
        imagesListService.fetchPhotosNextPage(token) { [weak self] result in
            switch result {
            case .success(let result):// Результат [Photo]
                guard let self = self else { return }
                self.photos = result
                print("Photos received")
                return
            case .failure(let error):
                print("FetchPhotos error: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Метод перехода к сингл контроллеру
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            //Обновлено
            let image = UIImage(named: photos[indexPath.row].thumbImageURL) // Подставляется индекс картинки
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource { // Данные
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Кол-во рядов в секции
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell") // Переиспользование ячейки
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath) // Вызов метода конфигурации ячейки
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate { // Делегат
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath) // Если выбрали ряд, то перейти на сингл контроллер
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // Перед отображением ячеек выставляется их финальная высота
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width // ? Ширина картинки
        let scale = imageViewWidth / imageWidth
        let cellHeigth = photo.size.height * scale + imageInsets.top + imageInsets.bottom // ? Высота картинки
        
        return cellHeigth
    }
}

extension ImagesListViewController { // Конфигурация ячейки
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL) {
            guard let date = photo.createdAt else { return }
            let placeholder = UIImage(named: "placeholder")
            cell.postImageView.contentMode = .center
            cell.postImageView.kf.indicatorType = .activity
            
            cell.postImageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: nil,
                progressBlock: nil
            ) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        cell.postImageView.contentMode = .scaleToFill
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .failure:
                    print("failed to load photos")
                }
            }
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        // Лайки
        let isLiked = indexPath.row % 2 == 0
        guard let likeImage = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_no_active") else { return }
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchPhotos()
    }
}
