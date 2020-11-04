//
//  PointCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class PointCell: UICollectionViewCell {
    var mainImage : UIImage?
        
    lazy var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = self.contentView.frame.size.width/2.0
        imageView.image = #imageLiteral(resourceName: "flower-check-active")
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainImageView)
        self.backgroundColor = .clear

    }

    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        
//        mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        mainImageView.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width).isActive = true
//        mainImageView.heightAnchor.constraint(equalToConstant: self.contentView.frame.size.width).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

