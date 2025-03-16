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
    
    func testPresenterCallsGetAvatarUrl() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.getAvatarUrl()
        
        //then
        XCTAssertTrue(presenter.getAvatarUrlCalled)
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
    
    func testSetupUICalls() {
        //given
        let viewController = ProfileViewControllerSpy()

        //when
        viewController.setupUI()

        //then
        XCTAssertTrue(viewController.setupUICalled)
    }
    
    func testUpdateAvatarCalls() {
        //given
        let viewController = ProfileViewControllerSpy()

        //when
        viewController.updateAvatar()

        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testDidTapLogOutButtonCalls() {
        //given
        let viewController = ProfileViewControllerSpy()

        //when
        viewController.didTapLogOutButton()

        //then
        XCTAssertTrue(viewController.didTapLogOutButtonCalled)
    }
}
