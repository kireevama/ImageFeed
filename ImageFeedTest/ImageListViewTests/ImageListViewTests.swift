//
//  ImageListViewTests.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 16.03.2025.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenterSpy = ImagesListViewPresenterSpy()
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsGetImages() {
        //given
        let imagesListServiceSpy = ImagesListServiceSpy()
        let presenter = ImagesListViewPresenter(imagesListService: imagesListServiceSpy)
        
        //when
        presenter.viewDidLoad()
        
        
        //then
        XCTAssertTrue(imagesListServiceSpy.fetchPhotosNextPageCalled)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        //given
        let viewControllerSpy = ImagesListViewControllerSpy()
        let imagesListServiceSpy = ImagesListServiceSpy()
        let presenter = ImagesListViewPresenter()
        viewControllerSpy.presenter = presenter
        presenter.view = viewControllerSpy
        presenter.imagesListService = imagesListServiceSpy
        
        //when
        
        let date = Date()
        let photo = Photo(id: "", size: CGSize(width: 10, height: 10), createdAt: date, welcomeDescription: "", thumbImageURL: "", largeImageURL: "", isLiked: false)
        
        presenter.photos.append(photo)
        presenter.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(viewControllerSpy.didUpdateTableViewAnimated)
    }
    
    
}
