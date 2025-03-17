//
//  ViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 23.09.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated()
    var oldCount: Int { get set }
    var newCount: Int { get set }
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var presenter: ImagesListViewPresenterProtocol?
    var oldCount = 0
    var newCount = 0
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    func updateTableViewAnimated() {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let photos = presenter?.photos else {
            return
        }
        
        if indexPath.row == photos.count - 1 {
            presenter?.getImages()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            UIBlockingProgressHUD.show()
            
            guard let photo = presenter?.photos[indexPath.row] else {
                print("Failed get photos from presenter")
                return
            }
            
            guard let url = URL(string: photo.largeImageURL) else {
                assertionFailure("Invalid or empty URL for image")
                return
            }
            
            viewController.imageURL = url
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Failed to receive cell")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photos[indexPath.row] else {
            print("Failed get photos from presenter")
            return
        }
        
        if let url = URL(string: photo.thumbImageURL) {
            
            cell.postImageView.kf.indicatorType = .activity
            let placeholder = UIImage(named: "placeholder")
            cell.postImageView.backgroundColor = UIColor(named: "YP White (Alpha 50)")
            cell.postImageView.contentMode = .center
            
            cell.postImageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: nil,
                progressBlock: nil
            ) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        cell.postImageView.contentMode = .scaleAspectFill
                        self?.presenter?.updateTableViewAnimated()
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
            
            if let createdDate = photo.createdAt {
                cell.dateLabel.text = dateFormatter.string(from: createdDate)
            } else {
                cell.dateLabel.text = ""
            }
            
            let likeImage = UIImage(named: photo.isLiked ? "like_active" : "like_no_active")
            cell.likeButton.setImage(likeImage, for: .normal)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.photos[indexPath.row] else {
            print("Failed get photos from presenter")
            return 1
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let photo = presenter?.photos[indexPath.row] else {
            print("Failed get photos from presenter")
            return
        }
        
        UIBlockingProgressHUD.show()

        presenter?.changeLike(for: photo) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    self?.presenter?.photos[indexPath.row].isLiked = isLiked
                    cell.setIsLiked(isLiked: isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    print("Error changing like to image")
                }
            }
        }
    }
}
