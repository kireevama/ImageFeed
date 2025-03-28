//
//  ProfileViewController.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 16.03.2025.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateAvatarCalled = false
    var didTapLogOutButtonCalled = false
    
    func setupUI() {
        
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func didTapLogOutButton() {
        didTapLogOutButtonCalled = true
    }
    
}
