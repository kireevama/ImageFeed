//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 26.09.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
   
    // MARK: - Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        postImageView.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        likeButton.setImage(UIImage(named: isLiked ? "like_active" : "like_no_active"), for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction private func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
