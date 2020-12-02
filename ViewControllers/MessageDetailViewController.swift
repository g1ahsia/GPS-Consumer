//
//  MessageDetailViewController.swift
//  TableInTable
//
//  Created by Michał Kaczmarek on 26.09.2017.
//  Copyright © 2017 Michał Kaczmarek. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String:UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary ))
    }
}


class MessageDetailViewController: UIViewController {
    
    var role : Role?
    var messages = [Message]()
    var tempImage : UIImage?
    var threadId : Int = 0
    var numCachedImages = [Int: Int]()
    var cachedImages = [Int: [UIImage]]()

    let messageDetailTableView: myTableView = myTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        tableView.reloadData()
        view.backgroundColor = UIColor.gray
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("AddedMessage"), object: nil)

    }
    
    func setupView() {
        messageDetailTableView.delegate = self
        messageDetailTableView.dataSource = self
        messageDetailTableView.separatorStyle = .none
        messageDetailTableView.register(MessageCell.self, forCellReuseIdentifier: "message")
        messageDetailTableView.backgroundColor = UIColor.green
        messageDetailTableView.separatorStyle = .singleLine
        
        view.addSubview(messageDetailTableView)
        view.addConstraintsWithFormat("V:|-60-[v0]-5-|", views: messageDetailTableView)
        view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: messageDetailTableView)
        
        messageDetailTableView.beginUpdates()
        messageDetailTableView.reloadData()
        messageDetailTableView.endUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageDetailTableView.reloadData()
    }
    
    @objc private func replyButtonTapped(sender: UIButton!) {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.ReplyMessage
        messageComposeVC.threadId = threadId
//        messageComposeVC.role = Role.MemberStore
        messageComposeVC.role = self.role
        if #available(iOS 13.0, *) {
            messageComposeVC.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(messageComposeVC, animated: true) {
        }
    }
    
    @objc func reloadData () {
        if (role == Role.Consumer) {
            NetworkManager.fetchMessages(id: threadId) { (messages) in
                
                DispatchQueue.main.async {
                    self.messages = messages

//                    self.messageDetailTableView.reloadData()
//                    self.messageDetailTableView.beginUpdates()
                    self.messageDetailTableView.reloadData()
//                    self.messageDetailTableView.endUpdates()

                }

//                for index in 0...messages.count - 1 {
//                    let attachments = self.messages[index].attachments
//                    let messageId = self.messages[index].id
//                    DispatchQueue.main.async {
//                        self.loadImages(attachments, indexPath: NSIndexPath(row: index, section: 0) as IndexPath, messageId: messageId)
//                    }
//                }
            }
        }
        else {
            NetworkManager.fetchStoreMessages(id: threadId) { (messages) in
                DispatchQueue.main.async {
//                    self.messageDetailTableView.reloadData()
                    
                    self.messages = messages

//                    self.messageDetailTableView.beginUpdates()
                    self.messageDetailTableView.reloadData()
//                    self.messageDetailTableView.endUpdates()

                }
            }
        }
    }

}

extension MessageDetailViewController: UITableViewDelegate {
    
}

extension MessageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == messageDetailTableView) {
            print ("num " + String(messages.count))
            return messages.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = SNOW
        if tableView == messageDetailTableView {
            footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
            let border = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
            border.backgroundColor = DEFAULT_SEPARATOR
            footerView.addSubview(border)
            let button =  UIButton()
            button.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.width - 20*2, height: 44)
            button.translatesAutoresizingMaskIntoConstraints = true
            button.setTitle("回覆", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
            button.backgroundColor = ATLANTIS_GREEN
            button.layer.cornerRadius = 10;
            button.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
            footerView.addSubview(button)
            return footerView

        }
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)

        return footerView

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == messageDetailTableView {
            return 64
        }
        else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        cell.sender = messages[indexPath.row].sender
        cell.message = messages[indexPath.row].message
        cell.date = messages[indexPath.row].date
        cell.imageUrls = messages[indexPath.row].attachments
        cell.layoutSubviews()
        return cell
    }
}
