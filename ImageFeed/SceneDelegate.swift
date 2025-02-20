//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 23.09.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        
        let splashViewController = SplashViewController()
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
 
}

