//
//  ViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/16.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tabBarCtrl: UITabBarController!
    
    var messageNav = UINavigationController()
    
    var customTabBarItem3 = UITabBarItem()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return .darkContent
            } else {
                return .darkContent
            }
        } else {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentLoginVC(notification:)), name: Notification.Name("Logout"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentMessageDetailVC(notification:)), name: Notification.Name("presentMessageDetailVC"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setMessageBadge), name: Notification.Name("setMessageBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearMessageBadge), name: Notification.Name("clearMessageBadge"), object: nil)


        let userDefaults = UserDefaults.standard

        // Read/Get Value
        let myToken = userDefaults.string(forKey: "myToken")
        let myStoreId = userDefaults.string(forKey: "myStoreId")
        
        if ((myToken) != nil) {
            // Do any additional setup after loading the view.
            TOKEN = myToken!
            STOREID = Int(myStoreId!) ?? 0

        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { // Change `0.05` to the desired number of seconds.
                NotificationCenter.default.post(name: Notification.Name("Logout"), object: nil)
            }
        }


        createTabBarController()
        
    }

    func createTabBarController() {
        tabBarCtrl = UITabBarController()
        tabBarCtrl?.tabBar.tintColor = PIGMENT_GREEN

        let homeVC = HomeViewController()
        
        let homeNav = UINavigationController()
        homeVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        homeNav.navigationBar.tintColor = ATLANTIS_GREEN
        homeNav.setNavigationBarHidden(false, animated: false)
        homeNav.pushViewController(homeVC, animated: true)
        let customTabBarItem1:UITabBarItem = UITabBarItem(title: "首頁", image: #imageLiteral(resourceName: " tab_ic_home_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_home_green"))
        homeNav.tabBarItem = customTabBarItem1

        let categoryVC = CategoryViewController()
        categoryVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let categoryNav = UINavigationController()
        categoryNav.navigationBar.tintColor = ATLANTIS_GREEN
        categoryNav.setNavigationBarHidden(false, animated: false)
        categoryNav.pushViewController(categoryVC, animated: true)
        let customTabBarItem2:UITabBarItem = UITabBarItem(title: "全部類別", image: #imageLiteral(resourceName: " tab_ic_list_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_list_green"))
        categoryNav.tabBarItem = customTabBarItem2
        
        let messageVC = MessageViewController()
        messageVC.role = Role.Consumer
        messageVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        messageNav = UINavigationController()
        messageNav.navigationBar.tintColor = ATLANTIS_GREEN
        messageNav.setNavigationBarHidden(false, animated: false)
        messageNav.pushViewController(messageVC, animated: true)
        customTabBarItem3 = UITabBarItem(title: "會員訊息", image: #imageLiteral(resourceName: " tab_ic_messages_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_messages_green"))
        messageNav.tabBarItem = customTabBarItem3

        let storeVC = StoreViewController()
        storeVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let storeNav = UINavigationController()
        storeNav.navigationBar.tintColor = ATLANTIS_GREEN
        storeNav.setNavigationBarHidden(false, animated: false)
        storeNav.pushViewController(storeVC, animated: true)

        let customTabBarItem4:UITabBarItem = UITabBarItem(title: "藥局介紹", image: #imageLiteral(resourceName: " tab_ic_info_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_info_green"))
        storeNav.tabBarItem = customTabBarItem4
        
        let accountVC = AccountViewController()
        accountVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let accountNav = UINavigationController()
        accountNav.navigationBar.tintColor = ATLANTIS_GREEN
        accountNav.setNavigationBarHidden(false, animated: false)
        accountNav.pushViewController(accountVC, animated: true)
        
        let customTabBarItem5:UITabBarItem = UITabBarItem(title: "我的帳號", image: #imageLiteral(resourceName: " tab_ic_user_grey"), selectedImage: #imageLiteral(resourceName: " tab_ic_user_green"))
        accountNav.tabBarItem = customTabBarItem5

        tabBarCtrl.viewControllers = [homeNav, categoryNav, messageNav, storeNav, accountNav]
        
        self.view.addSubview(tabBarCtrl.view)
        


    }
    @objc func presentLoginVC(notification: Notification) {
        let loginVC = LoginViewController()
        loginVC.view.backgroundColor = .white

        let loginNav = UINavigationController()
        loginNav.navigationBar.tintColor = ATLANTIS_GREEN
        loginNav.modalPresentationStyle = .fullScreen
        loginNav.pushViewController(loginVC, animated: true)

        self.present(loginNav, animated: false) {
            self.tabBarCtrl?.selectedIndex = 0
        }
    }
    @objc func presentMessageDetailVC(notification: Notification) {
        tabBarCtrl.selectedIndex = 2
        let userInfo = notification.userInfo;
        let messageDetailVC = MessageDetailViewController()
        messageDetailVC.role = Role.Consumer
        
        let threadId = (userInfo?["threadId"] as! NSString).integerValue
        let threadType = (userInfo?["threadType"] as! NSString).integerValue

//        let threadId = userInfo!["threadId"] as! Int32
//      // totalfup is a Double here
        //        let type = threads[indexPath.row].type - 1
        messageDetailVC.title = MESSAGE_SUBJECTS[threadType - 1]
        messageDetailVC.threadId = threadId
        messageDetailVC.reloadData()
        messageNav.popToRootViewController(animated: true)
        messageNav.pushViewController(messageDetailVC, animated: true)
    }
    
    @objc func setMessageBadge() {
        if (BADGES[0] > 0) {
            let badge_message = String(BADGES[0])
            customTabBarItem3.badgeValue = badge_message
        }
    }
    @objc func clearMessageBadge() {
        customTabBarItem3.badgeValue = nil
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedOnView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
