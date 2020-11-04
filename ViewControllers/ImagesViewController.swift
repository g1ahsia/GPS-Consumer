//
//  ImagesViewController.swift
//  ImageViewZoomDemo
//
//  Created by Amsaraj Mariappan on 15/9/2562 BE.
//  Copyright © 2562 Amsaraj Mariyappan. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    var scrollView = UIScrollView()
    var attachedImages = [UIImage]()
    var views = [UIView]()
    var imageViews = [ImageViewZoom]()
    var currentIndex = Int()
    
    var saveImage : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_download_white"), for: .normal)
        button.addTarget(self, action: #selector(saveImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cancel : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
//        button.frame = CGRect(x: 16, y: 16, width: 30, height: 30)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let viewHeight: CGFloat = self.view.bounds.size.height
        let viewWidth: CGFloat = self.view.bounds.size.width
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
//        let animals = ["tiger","horse","lion","horse","elephant"]
        var xPostion: CGFloat = 0
        
        for image in attachedImages {
            let view = UIView(frame: CGRect(x: xPostion, y: 0, width: viewWidth, height: viewHeight))
            let imageView = ImageViewZoom(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
            
            imageView.setup()
//            imageView.imageScrollViewDelegate = self
            imageView.imageContentMode = .aspectFit
            imageView.initialOffset = .center
            imageView.display(image: image)
//            imageView.layer.borderColor = UIColor .red.cgColor
//            imageView.layer.borderWidth = 2
            
            view.addSubview(imageView)
            scrollView.addSubview(view)
            xPostion += viewWidth
            
            views.append(view)
            imageViews.append(imageView)
        }
        scrollView.contentSize = CGSize(width: xPostion, height: viewHeight)
        view.addSubview(scrollView)
        
//        let cancel = UIButton()
        view.addSubview(cancel)
        cancel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true

        view.addSubview(saveImage)
        saveImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        scrollView.contentOffset = CGPoint(x: Int(self.view.bounds.size.width) * currentIndex, y: 0)

    }
    @objc private func cancelButtonTapped(sender: UIButton!) {
        self.dismiss(animated: true) {
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait

        }
    }
    
    @objc private func saveImageButtonTapped(sender: UIButton!) {
        
        UIImageWriteToSavedPhotosAlbum(attachedImages[currentIndex], self, #selector(savedImage), nil)
    }
    
    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        GlobalVariables.showAlert(title: MSG_TITLE_SAVE_IMAGE, message: MSG_IMAGE_SAVED, vc: self)
    }


}

extension ImagesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(self.view.bounds.size.width)
    }
}

extension ImagesViewController: ImageViewZoomDelegate {
    func imageScrollViewDidChangeOrientation(imageViewZoom: ImageViewZoom) {
        print("Did change orientation")
        let viewHeight: CGFloat = self.view.bounds.size.height
        let viewWidth: CGFloat = self.view.bounds.size.width
        scrollView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        var xPostion: CGFloat = 0

        for view in views {
            view.frame = CGRect(x: xPostion, y: 0, width: viewWidth, height: viewHeight)
            xPostion += viewWidth
        }
        for imageView in imageViews {
            imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            imageView.initialOffset = .center
        }
        scrollView.contentSize = CGSize(width: xPostion, height: viewHeight)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}

