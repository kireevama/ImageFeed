//
//  ProfileViewTests.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 15.03.2025.
//

@testable import ImageFeed
import XCTest
import Foundation

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLogOut() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.logOut()

        //then
        XCTAssertTrue(presenter.logOutCalled)
    }
    
    func testUpdateAvatarCalls() {
        //given
        let viewController = ProfileViewControllerSpy()

        //when
        viewController.updateAvatar()

        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testViewControllerUpdateProfile() {
            // given
            let viewController = ProfileViewController()
            let profile = Profile(username: "hello", name: "Name", loginName: "@login", bio: "Hello, world!")
            
            //when
            viewController.updateProfileDetails(profile: profile)
        
            //then
            XCTAssertEqual(viewController.nameLabel.text, profile.name)
            XCTAssertEqual(viewController.loginLabel.text, profile.loginName)
            XCTAssertEqual(viewController.descriptionLabel.text, profile.bio)
        }
    
    
}
