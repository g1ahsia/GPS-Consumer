//
//  ThreadCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//


import Foundation
import UIKit

class ThreadCell: UITableViewCell {
    var type : Int?
    var role : Role?
    var message : String?
    var sender : String?
    var updatedDate : String?
    var attachmentImage : UIImage?
        
    var subjectLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var messageView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.textColor = MYTLE

        return textView
    }()
    
    var senderLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 15)
        textLabel.textColor = MYTLE
        return textLabel
    }()

    var dateLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textAlignment = .right
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var attachmentImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear

        self.contentView.addSubview(subjectLabel)
        self.contentView.addSubview(messageView)
        self.contentView.addSubview(senderLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(attachmentImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let type = type {
            subjectLabel.text = MESSAGE_SUBJECTS[type]
        }
        if let role = role {
            if (role == Role.Consumer) {
                senderLabel.isHidden = true
                subjectLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:16).isActive = true
            }
            else if (role == Role.MemberStore) {
                senderLabel.isHidden = false
                senderLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
                senderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:16).isActive = true
                senderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
                senderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
                subjectLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4).isActive = true

            }
        }
        if let message = message {
            messageView.text = message
        }
        if let sender = sender {
            senderLabel.text = sender
        }
        if let date = updatedDate {
            dateLabel.text = date
        }
        if let image = attachmentImage {
            attachmentImageView.image = image
        }


        subjectLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        subjectLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4).isActive = true
        subjectLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        subjectLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        messageView.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 4).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -59).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true

        dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        attachmentImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        attachmentImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

