//
//  ProfileViewController.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 16.03.2025.
//

import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateAvatarCalled = false
    var setupUICalled = false
    var didTapLogOutButtonCalled = false
    
    func setupUI() {
        setupUICalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func didTapLogOutButton() {
        didTapLogOutButtonCalled = true
    }
    
    
}
