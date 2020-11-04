//
//  AccountViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/19.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    lazy var accountTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: "account")
        tableView.backgroundColor = .clear
        return tableView

    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if (self.accountTableView.indexPathForSelectedRow != nil) {
            self.accountTableView.deselectRow(at: self.accountTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "我的帳號"
        view.addSubview(accountTableView)
        accountTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()
    }
    
    private func setupLayout() {
        accountTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        accountTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        accountTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        accountTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath) as! TableCell
                
        switch indexPath.row {
        case 0:
            cell.field = "個人資料"
            break
//        case 1:
//            cell.textLabel?.text = "血壓血糖紀錄"
//            break
        case 1:
            cell.field = "優惠券使用紀錄"
            break
        case 2:
            cell.field = "集點卡兌換紀錄"
            break
        case 3:
            cell.field = "登出"
            break
        default:
            break
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                let accountDetailVC = AccountDetailViewController()
                accountDetailVC.id = 1
                self.navigationController?.pushViewController(accountDetailVC, animated: true)

                break
//            case 1:
//                break
            case 1:
                let couponUsageHistoryVC = CouponUsageHistoryViewController()
                self.navigationController?.pushViewController(couponUsageHistoryVC, animated: true)
                break
            case 2:
                let rewardCardsVC = RewardCardsViewController()
                rewardCardsVC.purpose = ConsumerSearchPurpose.LookUp
                self.navigationController?.pushViewController(rewardCardsVC, animated: true)

                break
            case 3:
                GlobalVariables.showAlertWithOptions(title: MSG_TITLE_LOGOUT, message: MSG_LOGOUT, confirmString: MSG_TITLE_LOGOUT, vc: self) {
                    print("已登出")
                    
                    UserDefaults.standard.removeObject(forKey: "myToken")

                    NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
                }
                if (self.accountTableView.indexPathForSelectedRow != nil) {
                    self.accountTableView.deselectRow(at: self.accountTableView.indexPathForSelectedRow!, animated: true)
                }
                break
            default:
                break
            }
    }
}
