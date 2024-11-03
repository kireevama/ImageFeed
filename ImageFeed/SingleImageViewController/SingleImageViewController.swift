//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 27.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageUIView.image = image
            
            singleImageUIView.frame.size = image?.size ?? CGSize(width: 300, height: 300)
        }
    }
    
    @IBOutlet private var singleImageUIView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageUIView.image = image
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageUIView
    }
}
