//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 25.10.2024.
//

import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
    func didTapLogOutButton()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private let profileService = ProfileService.shared
    
    private let imageView = UIImageView()
    let nameLabel = UILabel()
    let loginLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        setupUI()
        updateAvatar()
    }
    
    func setupUI() {
        // profileImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
        // nameLabel
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont(name: CustomFonts.bold.rawValue, size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        
        // loginLabel
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = UIFont(name: CustomFonts.regular.rawValue, size: 13)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        // descriptionLabel
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont(name: CustomFonts.regular.rawValue, size: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        
        // logOutButton
        let buttonImage = UIImage(named: "exit")
        guard let buttonImage = buttonImage else { return }
        
        let logOutButton = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(self.didTapLogOutButton))
        logOutButton.tintColor = UIColor(named: "YP Red")
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        logOutButton.accessibilityIdentifier = AccessibilityIdentifiers.logOutButton
        
        NSLayoutConstraint.activate([
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 24),
            logOutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return print("Profile is nil")
        }

        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        guard let url = presenter?.getAvatarUrl() else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "UserPickStub"), options: [.processor(processor)])
    }
    
    @objc
    func didTapLogOutButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.logOut()
            self?.switchToSplashViewController()
        }
        
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
    }
    
    func switchToSplashViewController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
    }
    
}
