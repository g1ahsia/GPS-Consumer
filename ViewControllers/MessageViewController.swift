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
    var numUnreads = 0

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
        let param = ["messages" : 0]
        if (role == Role.Consumer) {
            NetworkManager.updateBadges(parameters: param) { (result) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("fetchBadges"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: Notification.Name("clearMessageBadge"), object: nil, userInfo: nil)
                }
            }
        }
        else {
            NetworkManager.updateStoreBadges(parameters: param) { (result) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("fetchBadges"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: Notification.Name("clearMessageBadge"), object: nil, userInfo: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "會員訊息"
        view.addSubview(threadTableView)
        
        var image = UIImage(#imageLiteral(resourceName: "ic_fill_add"))
        image = image.withRenderingMode(.alwaysOriginal)
        let add = UIBarButtonItem(title: "新增", style: .done, target: self, action: #selector(self.addButtonTapped))

        self.navigationItem.rightBarButtonItem  = add

        threadTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
        
//        NotificationCenter.default.post(name: Notification.Name("getBadges"), object: nil, userInfo: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name:Notification.Name("CreatedThread"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("getCookies"), object: nil, userInfo: nil)
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
        cell.message = threads[indexPath.row].message
        cell.updatedDate = threads[indexPath.row].updatedDate
        cell.isRead = threads[indexPath.row].isRead
        cell.role = role
        cell.consumerId = threads[indexPath.row].consumerId
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetailVC = MessageDetailViewController()
        let type = threads[indexPath.row].type - 1
        messageDetailVC.title = MESSAGE_SUBJECTS[type]
        messageDetailVC.role = self.role
        
        if (role == Role.Consumer) {
            messageDetailVC.threadId = self.threads[indexPath.row].id
            messageDetailVC.reloadData()
            self.navigationController?.pushViewController(messageDetailVC, animated: true)
        }
        else {
            
            messageDetailVC.threadId = self.threads[indexPath.row].id
            messageDetailVC.reloadData()
            let cell = threadTableView.cellForRow(at: indexPath) as! ThreadCell
            messageDetailVC.consumerId = cell.consumerId
            self.navigationController?.pushViewController(messageDetailVC, animated: true)
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
