//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Marina Kireeva on 21.02.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService.shared
            
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
            
        service.fetchPhotosNextPage(<#String#>, completion: <#(Result<[Photo], Error>) -> Void#>)
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }
}
