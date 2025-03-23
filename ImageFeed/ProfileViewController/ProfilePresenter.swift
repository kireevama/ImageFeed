//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 12.03.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getAvatarUrl() -> URL?
    func logOut()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        
    }
    
    func getAvatarUrl() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        
        return url
    }
    
    func logOut() {
        profileLogoutService.logout()
    }
    
}
