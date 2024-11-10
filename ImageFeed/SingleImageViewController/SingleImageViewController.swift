//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 27.10.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var singleImageUIView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Private properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImageUIView.image = image
            
            guard let image = image else { return }
            singleImageUIView.frame.size = image.size // new
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Override funcs
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
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(share, animated: true, completion: nil)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageUIView
    }
}

// MARK: - Extensions
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
