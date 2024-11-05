//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 27.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet private var singleImageUIView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageUIView.image = image
            
            //new
            guard let image = image else { return }
//            singleImageUIView.frame.size = image.size
            
            //увеличиваем катинку на весь экран
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageUIView.image = self.image
        
        //увеличиваем катинку на весь экран
        guard let image = image else { return }
        rescaleAndCenterImageInScrollView(image: image)
        
        // Значения для зума
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

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
