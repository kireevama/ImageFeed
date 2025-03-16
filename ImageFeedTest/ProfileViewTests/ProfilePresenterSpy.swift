//
//  ProfilePresenterSpy.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 15.03.2025.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var getAvatarUrlCalled = false
    var logOutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getAvatarUrl() -> URL? {
        getAvatarUrlCalled = true
        return nil
    }
    
    func logOut() {
        logOutCalled = true
    }
    
    
}
