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
    var bottomConstraint: NSLayoutConstraint?

    
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
//        for imageView in attachmentImageViews {
//            imageView.image = nil
//            imageView.removeFromSuperview()
//        }
        attachmentImageViews.removeAll()
        self.removeAllConstraints()
        bottomConstraint?.isActive = false
    }

    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let sender = sender {
            senderLabel.text = sender
        }
        if let message = message {
            messageView.text = message
        }
        if let date = date {
            dateLabel.text = date
        }

        senderLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        senderLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        senderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        senderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        messageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true

        dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        bottomConstraint?.isActive = false
        
        if attachedImages.count > 0 {
            attachmentImageViews.removeAll()
            for attachedImage in attachedImages {
                let imageView = UIImageView(image: attachedImage)
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                attachmentImageViews.append(imageView)
                
                let tapImageView = MyTapGestureRecognizer(target: self, action: #selector(handleTap))
                tapImageView.imageView = imageView
                imageView.addGestureRecognizer(tapImageView)

                self.contentView.addSubview(imageView)
            }
            for index in 0..<attachedImages.count {
                if (index == 0) {
                    attachmentImageViews[index].topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 16).isActive = true
                }
                else {
                    attachmentImageViews[index].topAnchor.constraint(equalTo: attachmentImageViews[index-1].bottomAnchor, constant: 5).isActive = true
                }
                attachmentImageViews[index].leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
                attachmentImageViews[index].rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
                attachmentImageViews[index].heightAnchor.constraint(equalToConstant: self.contentView.frame.size.width  * (attachmentImageViews[index].image?.size.height)!/(attachmentImageViews[index].image?.size.width)!).isActive = true
//                attachmentImageViews[index].heightAnchor.constraint(equalTo: attachmentImageViews[index].widthAnchor, multiplier: (attachmentImageViews[index].image?.size.height)!/(attachmentImageViews[index].image?.size.width)!).isActive = true

                if (index == attachedImages.count - 1) {
                    bottomConstraint = attachmentImageViews[index].bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
                    bottomConstraint?.isActive = true
                }
            }
        }
        else {
//            if (attachments.count > 0) {
//                bottomConstraint = messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -200)
////            messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
//            }
//            else {
                bottomConstraint = messageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
//            }
            bottomConstraint?.isActive = true
        }
        
    
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

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
