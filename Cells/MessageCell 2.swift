//
//  MessageCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/29.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class MessageCell: UITableViewCell {
    var subject : String?
    var sender : String?
    var message : String?
    var date : String?
    var attachments = [String]()
    var attachedImages = [UIImage]()
    weak var viewController : UIViewController?
    
//    var textHeightConstraint: NSLayoutConstraint!


    var senderLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 15)
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var messageView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.textColor = MYTLE
        return textView
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
        
    var attachmentImageViews = [UIImageView]()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear

        self.contentView.addSubview(senderLabel)
        self.contentView.addSubview(messageView)
        self.contentView.addSubview(dateLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    
    override func layoutSubviews() {
        super .layoutSubviews()
        print("layoutsubviews")
        if let sender = sender {
            senderLabel.text = sender
        }
        if let message = message {
            messageView.text = message
        }
        if let date = date {
            dateLabel.text = date
        }
        for imageView in attachmentImageViews {
            imageView.removeFromSuperview()
        }
        
        let myGroup = DispatchGroup()

        if attachments.count > 0 {
            for imageUrl in attachments {
                myGroup.enter()
                downloadImage(from: imageUrl) { (data) in
                    let image = UIImage(data: data)
                    if let image = image {
                        self.attachedImages.append(image)
                    }
                    myGroup.leave()
                }
            }
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                self.layoutViews()
            }
        }
    }
    
    private func layoutViews() {
        print("layoutViews")
        if self.attachedImages.count > 0 {
            self.attachmentImageViews.removeAll()
            for attachedImage in self.attachedImages {
                let imageView = UIImageView(image: attachedImage)
                imageView.isUserInteractionEnabled = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.attachmentImageViews.append(imageView)
                
                let tapImageView = MyTapGestureRecognizer(target: self, action: #selector(handleTap))
                tapImageView.imageView = imageView
                imageView.addGestureRecognizer(tapImageView)

                self.contentView.addSubview(imageView)
            }
            for index in 0..<self.attachedImages.count {
                if (index == 0) {
                    self.attachmentImageViews[index].topAnchor.constraint(equalTo: self.messageView.bottomAnchor, constant: 16).isActive = true
                }
                else {
                    self.attachmentImageViews[index].topAnchor.constraint(equalTo: self.attachmentImageViews[index-1].bottomAnchor, constant: 5).isActive = true
                }
                self.attachmentImageViews[index].leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
                self.attachmentImageViews[index].rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
                self.attachmentImageViews[index].heightAnchor.constraint(equalTo: self.attachmentImageViews[index].widthAnchor, multiplier: (self.attachmentImageViews[index].image?.size.height)!/(self.attachmentImageViews[index].image?.size.width)!).isActive = true

                if (index == self.attachedImages.count - 1) {
                    self.attachmentImageViews[index].bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
                }
            }
        }
        else {
            self.messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
        }
        
        self.senderLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        self.senderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.senderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.senderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.messageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        self.messageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40).isActive = true
        self.messageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true

        self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        self.dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func replyButtonTapped(sender: UIButton!) {

    }
    @objc func handleTap(gestureRecognizer: MyTapGestureRecognizer) {
        let imagesVC = ImagesViewController()
        imagesVC.attachedImages = self.attachedImages
        imagesVC.modalPresentationStyle = .overFullScreen
        if let imageView = gestureRecognizer.imageView {
            imagesVC.currentIndex = attachmentImageViews.firstIndex(of: imageView)!
            self.viewController!.present(imagesVC, animated: true)
        }
    }
}

//extension MessageContentCell: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        self.adjustTextViewHeight()
//    }
//
//    func adjustTextViewHeight() {
//        let fixedWidth = messageView.frame.size.width
//        let newSize = messageView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
////        self.textHeightConstraint.constant = newSize.height
//        self.contentView.layoutIfNeeded()
//    }
//
//}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var imageView: UIImageView?
}
