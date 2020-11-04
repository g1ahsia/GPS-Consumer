//
//  MerchandiseCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class MerchandiseCell: UICollectionViewCell {
    var mainImage : UIImage?
    var name : String?
    var price : String?
    var imageUrls : [String]?
        
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 232/255, green: 236/255, blue: 238/255, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = PATTENS_BLUE.cgColor
        return imageView
    }()
    
    var mainImageBackground : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Medium", size: 15)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;
        return textView
    }()

    var priceLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont(name: "PingFangTC-Regular", size: 17)
        label.textColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainImageBackground)
        mainImageBackground.addSubview(mainImageView)
        self.addSubview(nameView)
        self.addSubview(priceLabel)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true;
        self.contentView.backgroundColor = WHITE_SMOKE
    }

    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameView.text = name
        }
        if let price = price {
            priceLabel.text = price
        }
        if imageUrls != nil {
            if imageUrls!.count > 0 {
                for case let imageURL in imageUrls! {
//                    mainImageView.downloaded(from: imageURL) {
                    mainImageView.image = #imageLiteral(resourceName: "gps_line_13")
//                    }
                }
            }
        }
        mainImageBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainImageBackground.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 49) / 2).isActive = true
        mainImageBackground.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 180/163).isActive = true
        mainImageBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        mainImageView.leftAnchor.constraint(equalTo: mainImageBackground.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainImageBackground.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: mainImageBackground.rightAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: mainImageBackground.bottomAnchor).isActive = true

        nameView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        nameView.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor).isActive = true
        nameView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
//        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        priceLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 38).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

