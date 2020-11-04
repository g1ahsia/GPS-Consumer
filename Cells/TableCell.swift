//
//  TableCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/8/3.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    var field : String?
    
    var fieldLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textLabel.sizeToFit()
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var arrowRight : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.addSubview(fieldLabel)
        self.addSubview(arrowRight)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        if let field = field {
            fieldLabel.text = field
        }

        fieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        fieldLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        fieldLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        arrowRight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowRight.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
