//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 26.09.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
    // MARK: - Properties
    static let reuseIdentifier = "ImagesListCell"
}
