//
//  MessageDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/29.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class MessageDetailViewController: UIViewController {
    var role : Role?
    var messages = [Message]()
    var tempImage : UIImage?
    var threadId : Int = 0
    
//    let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: 44))
    
    lazy var messageDetailTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "message")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        view.addSubview(messageDetailTableView)
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("AddedMessage"), object: nil)
    }
    
    @objc private func addButtonTapped() { }
    
    private func setupLayout() {
        if let role = role {
            if (role == Role.Consumer) {
            }
            else {
                var image = UIImage(#imageLiteral(resourceName: " tab_ic_user_green"))
                image = image.withRenderingMode(.alwaysOriginal)
                let customer = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.customerButtonTapped)) //
                self.navigationItem.rightBarButtonItem  = customer
            }
        }
        messageDetailTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        messageDetailTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        messageDetailTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        messageDetailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc private func customerButtonTapped() {
        let consumerDetailVC = ConsumerDetailViewController()
        consumerDetailVC.id = 1
        self.navigationController?.pushViewController(consumerDetailVC, animated: true)
    }

}

extension MessageDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == messageDetailTableView) {
            return messages.count
        }
        else {
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        cell.viewController = self
        if (indexPath.row == 0) {
            cell.sender = messages[indexPath.row].sender
            cell.message = messages[indexPath.row].message
            cell.date = messages[indexPath.row].date
            if let image = tempImage {
                cell.attachedImages = [image, #imageLiteral(resourceName: "001246")]
            }
            cell.layoutSubviews()
        }
        else {
            cell.sender = messages[indexPath.row].sender
            cell.message = messages[indexPath.row].message
            cell.date = messages[indexPath.row].date
            cell.layoutSubviews()
        }
//
//        else if (indexPath.row < 6) {
//            cell.sender = "松仁藥局"
//            cell.message = "沒有"
//            cell.date = "2020/04/22 15:35"
//            cell.attachedImages = [#imageLiteral(resourceName: "prescription"), #imageLiteral(resourceName: "item-1")]
//            cell.layoutSubviews()
//        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
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

    @objc private func replyButtonTapped(sender: UIButton!) {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.Reply
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
    
    @objc private func reloadData () {
        if (role == Role.Consumer) {
            NetworkManager.fetchMessages(id: threadId) { (messages) in
                self.messages = messages
                DispatchQueue.main.async {
                    self.messageDetailTableView.reloadData()
                }
            }
        }
        else {
            NetworkManager.fetchStoreMessages(id: threadId) { (messages) in
                self.messages = messages
                DispatchQueue.main.async {
                    self.messageDetailTableView.reloadData()
                }
            }
        }
    }

}
