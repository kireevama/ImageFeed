//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 25.10.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // profileImage
        let profileImage = UIImage(named: "photo")
        let imageView = UIImageView(image: profileImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
        // nameLable
        let nameLable = UILabel()
        nameLable.text = "Екатерина Новикова"
        nameLable.textColor = UIColor(named: "YP White")
        nameLable.font = UIFont(name: CustomFonts.bold.rawValue, size: 23)
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLable)
        
        nameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLable.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        // loginLable
        let loginLable = UILabel()
        loginLable.text = "@ekaterina_nov"
        loginLable.textColor = UIColor(named: "YP Gray")
        loginLable.font = UIFont(name: CustomFonts.regular.rawValue, size: 13)
        
        loginLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLable)
        
        loginLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8).isActive = true
        
        // descriptionLable
        let descriptionLable = UILabel()
        descriptionLable.text = "Hello, world!"
        descriptionLable.textColor = UIColor(named: "YP White")
        descriptionLable.font = UIFont(name: CustomFonts.regular.rawValue, size: 13)
        
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLable)
        
        descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLable.topAnchor.constraint(equalTo: loginLable.bottomAnchor, constant: 8).isActive = true
        
        // logOutButton
        let buttonImage = UIImage(named: "exit")
        guard let buttonImage = buttonImage else { return }
        
        let logOutButton = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(self.didTaplogOutButton))
        logOutButton.tintColor = UIColor(named: "YP Red")
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logOutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 24),
            logOutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    
    }
    
    @objc
    private func didTaplogOutButton() {
        return
    }
}
