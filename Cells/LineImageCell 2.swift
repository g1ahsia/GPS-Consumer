//
//  LineImageCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/8/3.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class LineImageCell: UICollectionViewCell {
    var mainImage : UIImage?
        
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainImageView)
        self.contentView.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
