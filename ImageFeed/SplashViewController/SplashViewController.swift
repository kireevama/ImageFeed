//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 13.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) { // Сразу отображаем SplashView, потом решаем куда перенаправить дальше
        
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            print("Token received")

            guard let token = storage.token else {
                print("Failed get token")
                return
            }
            
            fetchProfile(token)
        } else {
            print("Token not found")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil) // Показываем экран авторизации, если токена нет
        }
    }
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "LaunchScreen")
        return imageView
    }()
    
    private func setupUI() {
        view.addSubview(splashImageView)
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithToken token: String) {
        print("Did Authenticate: \(token)")
        vc.dismiss(animated: true)

        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token)
        self.switchToTabBarController()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
            self.profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }
            switch result {
            case .success (let profile):
                self.fetchProfileImageURL(token: token, username: profile.username)
//                self.switchToTabBarController()
            case .failure:
                print("Error getting profile")
                break
            }
        }
    }
    
    private func fetchProfileImageURL(token: String, username: String) {
        self.profileImageService.fetchProfileImageURL(token: token, username: username) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success:
                print("Image URL received")
                self.switchToTabBarController()
            case .failure:
                print("Error getting profile image URL")
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Error getting authViewController")
            return
        }
        
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}
