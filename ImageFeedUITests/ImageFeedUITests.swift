//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Marina Kireeva on 18.03.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    private enum UserDataForTests {
        static let email = ""
        static let password = ""
        static let name = ""
        static let login = ""
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // Нажать кнопку авторизации
        app.buttons[AccessibilityIdentifiers.authButton].tap()
        
        //Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews[AccessibilityIdentifiers.authWebView]
        XCTAssertTrue(webView.waitForExistence(timeout: 8))

        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(UserDataForTests.email)
        sleep(2)
        
        let toolbar = app.toolbars["Toolbar"]
        let nextButton = toolbar.buttons["Next"]
        nextButton.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(UserDataForTests.password)
        sleep(2)

        // Нажать кнопку логина
        webView.buttons["Login"].tap()

        print(app.debugDescription) // печатает в консоль дерево UI-элементов
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        sleep(5)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Поставить и отменить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons[AccessibilityIdentifiers.likeButton].tap()
        cellToLike.buttons[AccessibilityIdentifiers.likeButton].tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        
        // Нажать на верхнюю ячейку
        cellToLike.tap()
        // Подождать, пока картинка открывается на весь экран
        sleep(5)
        
        // Зум картинки
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        // Вернуться на экран ленты
        let navBackButton = app.buttons[AccessibilityIdentifiers.navBackButton]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        sleep(5)
        
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()

        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts[UserDataForTests.name].exists)
        XCTAssertTrue(app.staticTexts[UserDataForTests.login].exists)
        
        // Нажать кнопку логаута
        app.buttons[AccessibilityIdentifiers.logOutButton].tap()
        
        // Проверить, что появился алерт
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        // Проверить, что открылся экран авторизации
        let webView = app.buttons["Войти"]
        XCTAssertTrue(webView.waitForExistence(timeout: 8))
    }
    
}
