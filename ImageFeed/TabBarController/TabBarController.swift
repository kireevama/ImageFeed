//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 18.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "ImagesListNavigationController") as? UINavigationController else {
            assertionFailure("Error getting authViewController")
            return
        }
        
        navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile_active"),
            selectedImage: nil
        )
        self.viewControllers = [navigationController, profileViewController]
    }
}
