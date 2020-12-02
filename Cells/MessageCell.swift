//
//  MessageCell.swift
//  TableInTable
//
//  Created by Michał Kaczmarek on 26.09.2017.
//  Copyright © 2017 Michał Kaczmarek. All rights reserved.
//

import UIKit

class myTableView : UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}

class MessageCell: UITableViewCell {
    
//    var myTableView: OwnTableView = OwnTableView()
    var sender : String?
    var message : String?
    var date : String?
    var imageUrls = [String]()
    var number: Int!

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
    
    lazy var imageTableView : myTableView = {
        var tableView = myTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.rowHeight = UITableView.UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 300
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageCell.self, forCellReuseIdentifier: "image")
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.brown
        setupView()
        imageTableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
//        myTableView.delegate = self
//        myTableView.dataSource = self
//        myTableView.separatorStyle = .singleLineEtched
//        myTableView.backgroundColor = UIColor.blue
//        myTableView.register(ImageCell.self, forCellReuseIdentifier: "image")
//        myTableView.isScrollEnabled = false
//        myTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(senderLabel)
        addSubview(messageView)
        addSubview(dateLabel)
        addSubview(imageTableView)
        
    
    }
    
    override func layoutSubviews() {
        if let sender = sender {
            senderLabel.text = sender
        }
        if let message = message {
            messageView.text = message
        }
        if let date = date {
            dateLabel.text = date
        }

//        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: senderLabel)

        addConstraint(NSLayoutConstraint(item: senderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: senderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16))

        addConstraint(NSLayoutConstraint(item: senderLabel, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200))
//
        addConstraint(NSLayoutConstraint(item: senderLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20))
//
//        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: messageView)
//
        addConstraint(NSLayoutConstraint(item: messageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 40))
        
        addConstraint(NSLayoutConstraint(item: messageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: messageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16))

//
////        addConstraintsWithFormat("H:|-16-[v0]-20-|", views: dateLabel)
//
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 16))

        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -20))

        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200))
//
//
//        addConstraintsWithFormat("H:|-30-[v0]-30-|", views: myTableView)

        addConstraint(NSLayoutConstraint(item: imageTableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: imageTableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -16))

        addConstraint(NSLayoutConstraint(item: imageTableView, attribute: .top, relatedBy: .equal, toItem: messageView, attribute: .bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: imageTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -16))
        

    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        imageUrls = []
    }

}

extension MessageCell: UITableViewDelegate {
    
}

extension MessageCell: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if nil == number {
//            number = 1 + Int(arc4random_uniform(UInt32(10 - 1 + 1)))
//        }
//        return number
        print("number of images \(imageUrls.count)")
        return imageUrls.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! ImageCell
        print("index is \(indexPath.row)")
        cell.imageUrl = imageUrls[indexPath.row]
        cell.setImage()
        cell.layoutIfNeeded()
        return cell
    }
}
