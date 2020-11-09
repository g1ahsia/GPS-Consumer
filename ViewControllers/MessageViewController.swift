//
//  MessageViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class MessageViewController: UIViewController {
    
    var role : Role?
    var threads = [Thread]()

    lazy var threadTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 102
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ThreadCell.self, forCellReuseIdentifier: "thread")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.threadTableView.indexPathForSelectedRow != nil) {
            self.threadTableView.deselectRow(at: self.threadTableView.indexPathForSelectedRow!, animated: true)
        }
        self.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "會員訊息"
        view.addSubview(threadTableView)
        
        var image = UIImage(#imageLiteral(resourceName: "ic_fill_add"))
        image = image.withRenderingMode(.alwaysOriginal)
//        let add = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.addButtonTapped)) //
        let add = UIBarButtonItem(title: "新增", style: .done, target: self, action: #selector(self.addButtonTapped))

        self.navigationItem.rightBarButtonItem  = add

//        threads = [
//            Thread.init(id: 1, type: 1, isRead: true, sender: "王大寶", message: "處方箋如附件", updatedDate: "2020/04/25 15:35"),
//            Thread.init(id: 2, type: 0, isRead: true, sender: "張曉玲", message: "藥品有無副作用", updatedDate: "2020/04/23 15:35"),
//            Thread.init(id: 3, type: 2, isRead: true, sender: "何大中", message: "最近體重的事情一直煩惱著我，想請教如何減重？我真的很需要建議，謝謝！", updatedDate: "2020/04/20 15:35")
//        ]
        
//        NetworkManager.fetchThreads() { (threads) in
//            self.threads = threads
//            DispatchQueue.main.async {
//                self.threadTableView.reloadData()
//            }
//        }

        threadTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("CreatedThread"), object: nil)

    }
    
    @objc private func addButtonTapped() {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.New
        messageComposeVC.role = role
        if #available(iOS 13.0, *) {
            messageComposeVC.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(messageComposeVC, animated: true) {
        }
    }
    
    private func setupLayout() {
        threadTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        threadTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        threadTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        threadTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == threadTableView) {
            return threads.count
        }
        else {
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thread", for: indexPath) as! ThreadCell
        cell.sender = threads[indexPath.row].sender
        cell.type = threads[indexPath.row].type
//        cell.type = 1
        cell.message = threads[indexPath.row].message
        cell.updatedDate = threads[indexPath.row].updatedDate
        cell.isRead = threads[indexPath.row].isRead
        cell.role = role
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailVC = MessageDetailViewController()
        messageDetailVC.title = MESSAGE_SUBJECTS[threads[indexPath.row].type]
        messageDetailVC.role = self.role
        if (role == Role.Consumer) {
//            NetworkManager.fetchMessages(id: threads[indexPath.row].id) { (messages) in
//                messageDetailVC.messages = messages
//                messageDetailVC.threadId = self.threads[indexPath.row].id
//                DispatchQueue.main.async {
//                    self.navigationController?.pushViewController(messageDetailVC, animated: true)
//                }
//            }
            messageDetailVC.threadId = self.threads[indexPath.row].id
            messageDetailVC.reloadData()
            self.navigationController?.pushViewController(messageDetailVC, animated: true)
        }
        else {
            NetworkManager.fetchStoreMessages(id: threads[indexPath.row].id) { (messages) in
                messageDetailVC.messages = messages
                messageDetailVC.threadId = self.threads[indexPath.row].id
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(messageDetailVC, animated: true)
                }
            }
        }

    }
    
    @objc private func reloadData () {
        
        if (role == Role.Consumer) {
            NetworkManager.fetchThreads() { (threads) in
                self.threads = threads
                DispatchQueue.main.async {
                    self.threadTableView.reloadData()
                }
            }
        }
        else {
            NetworkManager.fetchStoreThreads() { (threads) in
                self.threads = threads
                DispatchQueue.main.async {
                    self.threadTableView.reloadData()
                }
            }
        }
    }
}



