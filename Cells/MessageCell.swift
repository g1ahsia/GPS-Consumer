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
        textView.sizeToFit()
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
        for imageView in attachmentImageViews {
            imageView.image = nil
            imageView.removeFromSuperview()
        }
        attachmentImageViews.removeAll()        
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

        let size = messageView.sizeThatFits(CGSize(width: self.contentView.frame.size.width - 32, height: CGFloat.greatestFiniteMagnitude))
        senderLabel.frame = CGRect(x: 16, y: 16, width: 200, height: 20)
        messageView.frame = CGRect(x: 16, y: 40, width: self.contentView.frame.size.width - 32, height: size.height)
        dateLabel.frame = CGRect(x: self.contentView.frame.size.width - 20 - 200, y: 16, width: 200, height: 20)
        
        if attachedImages.count > 0 {
            for imageView in attachmentImageViews {
                imageView.image = nil
                imageView.removeFromSuperview()
            }
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
                    attachmentImageViews[index].frame = CGRect(x: 16, y: messageView.frame.origin.y + messageView.frame.size.height + 16, width: self.contentView.frame.size.width - 32, height: 200)
                }
                else {
                    attachmentImageViews[index].frame = CGRect(x: 16, y: attachmentImageViews[index-1].frame.origin.y + attachmentImageViews[index-1].frame.size.height + 16, width: self.contentView.frame.size.width - 32, height: 200)
                }
            }
        }
        else {
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

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var imageView: UIImageView?
}
