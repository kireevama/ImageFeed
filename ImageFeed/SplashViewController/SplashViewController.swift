//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 13.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    
    // new
    private let profileService = ProfileService.shared
    // new
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    
    override func viewDidAppear(_ animated: Bool) { // Сразу отображаем SplashView, потом решаем куда перенаправить дальше
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            print("Token received")
            switchToTabBarController()
            
            //new
            guard let token = storage.token else {
                print("Failed get token")
                return
            }
            fetchProfile(token)
            //new
            
        } else {
            print("Token not found")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil) // Показываем экран авторизации, если токена нет
        }
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
        
        //new
        guard let token = storage.token else {
            return
        }
        fetchProfile(token)
        //new
        
        self.switchToTabBarController()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
            self.profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                //new
                
                //new
            case .failure:
                print("Error getting profile")
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
