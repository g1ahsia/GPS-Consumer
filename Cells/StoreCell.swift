//
//  StoreCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/7.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class StoreCell: UITableViewCell {
    var store : String?
    var storeID : String?
    
    var storeLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.sizeToFit()
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var storeIDLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.textColor = MYTLE
        return textLabel
    }()

    var checkMarkImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: " ic_fill_check")
        return imageView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(storeLabel)
        self.addSubview(storeIDLabel)
        self.addSubview(checkMarkImageView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
        if (selected) {
            checkMarkImageView.isHidden = false
        }
        else {
            checkMarkImageView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        if let store = store {
            storeLabel.text = store
        }
        if let storeID = storeID {
            storeIDLabel.text = storeID
        }


        storeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        storeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        storeIDLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48).isActive = true
        storeIDLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        storeIDLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        checkMarkImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkMarkImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
