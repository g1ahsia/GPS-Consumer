//
//  MissionDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/26.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
//import FBSDKLoginKit


class MissionDetailViewController: UIViewController {
    var mainImage : UIImage?
    var name : String?
    var desc : String?
    var pageIDs = [[String : String]]()

    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
        
    var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = true;
        return imageView
    }()
    
    var nameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 20)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true;
        textLabel.textAlignment = .center
        return textLabel
    }()

    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;

        return textView
    }()
    var complete : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("完成任務", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var hintLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 11)
        textLabel.textAlignment = .center
        textLabel.text = "請由店員操作兌換"
        return textLabel
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SNOW
        title = "任務"
        view.addSubview(mainScrollView)

        mainScrollView.addSubview(mainImageView)
        mainScrollView.addSubview(nameLabel)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(complete)
//        mainScrollView.addSubview(check)
        mainScrollView.addSubview(hintLabel)

        setupLayout()
        
//        let loginButton = FBLoginButton()
//        loginButton.center = view.center
//        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)

//        if let token = AccessToken.current,
//            !token.isExpired {
//            // User is logged in, do work such as go to next view controller.
//
//            if (AccessToken.current?.hasGranted(permission: "user_likes") != nil) {
//                let graphRequest = GraphRequest(graphPath: "me/likes", parameters: ["fields":"id"])
//                let connection = GraphRequestConnection()
//                connection.add(graphRequest, completionHandler: { (connection, result, error) in
//
//                    if error != nil {
//
//                        //do something with error
//                        print("error is", error!)
//                    }
//                    if let result = result as? [String : Any],
//                        let pages = result["data"] as? [[String : String]] {
//                        self.pageIDs.append(contentsOf: pages)
//                        if let paging = result["paging"] as? [String : Any],
//                            let next = paging["next"] as? String {
//                            print("next paging ", next)
//                            self.fetchMorePages(urlString: next)
//                        }
//                    }
//
//                })
//                connection.start()
//            }
//        }
    }
    
    private func setupLayout() {
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameLabel.text = name
        }
        if let desc = desc {
            descView.text = desc
        }
        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 256/375).isActive = true

        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40)).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 40).isActive = true

        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        complete.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        complete.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 40).isActive = true
        complete.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        complete.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        use.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true
        
        hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: complete.bottomAnchor, constant: 10).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
//        check.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        check.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 40).isActive = true
//        check.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        check.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        check.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true
        

    }
    @objc private func addButtonTapped() { }
    
    @objc private func completeButtonTapped(sender: UIButton!) {
        
//        self.pageIDs = [[String : String]]()
//        if let token = AccessToken.current,
//            !token.isExpired {
//            // User is logged in, do work such as go to next view controller.
//            getLikes()
//
//        }
//        else {
//
//            
//            let login = LoginManager()
//            login.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//                if error != nil {
//                    return
//                }
//                //make sure we have a result, otherwise abort
//                guard let result = result else { return }
//                //if cancelled nothing todo
//                if result.isCancelled { return }
//                else {
//                    
//                    self.getLikes()
//                }
//            }
//        }

    }
    
//    private func getLikes() {
//        if (AccessToken.current?.hasGranted(permission: "user_likes") != nil) {
//            let graphRequest = GraphRequest(graphPath: "me/likes", parameters: ["fields":"id"])
//            let connection = GraphRequestConnection()
//            connection.add(graphRequest, completionHandler: { (connection, result, error) in
//
//                if error != nil {
//
//                    //do something with error
//                    print("error is", error!)
//                }
//                if let result = result as? [String : Any],
//                    let pages = result["data"] as? [[String : String]] {
//                    self.pageIDs.append(contentsOf: pages)
//                    if let paging = result["paging"] as? [String : Any],
//                        let next = paging["next"] as? String {
//                        print("next paging ", next)
//                        self.fetchMorePages(urlString: next)
//                    }
//                }
//
//            })
//            connection.start()
//        }
//    }
    
//    func fetchMorePages(urlString : String) {
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//            var store = Store.init(id: 0, code: "", name: "", latitude: 0, longitude: 0)
//            if let error = error {
//                print("Error with fetching store: \(error)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                    print("Error with the response, unexpected status code: \(String(describing: response))")
//              return
//            }
//
//            if let data = data,
//                let result = try? JSONSerialization.jsonObject(with: data, options: []) {
//                if let result = result as? [String : Any],
//                    let pages = result["data"] as? [[String : String]] {
//                    self.pageIDs.append(contentsOf: pages)
//                    if let paging = result["paging"] as? [String : Any],
//                        let next = paging["next"] as? String {
//                        print("next paging ", next)
//                        self.fetchMorePages(urlString: next)
//                    }
//                    else {
//                        print("got all pages here\(self.pageIDs.count)")
//                        self.checkGPSLike()
//                    }
//                }
//
//            }
//        })
//        task.resume()
//    }
    
//    func checkGPSLike() {
//        for dict in self.pageIDs {
//            if (dict["id"] == "262951807595060") {
//                print("liked page")
//                return
//            }
//        }
//        print("didn't like page")
////        goToFBPage()
//        DispatchQueue.main.async {
//            GlobalVariables.showAlert(title: MSG_TITLE_FB, message: LIKE_FACEBOOK_PAGE, vc: self)
//        }
//
//    }
    
//    private func goToFBPage() {
//        
//        guard let facebookURL = NSURL(string: "fb://page/?id=your_page_numeric_id") else {
//            return
//        }
//
//        if (UIApplication.shared.canOpenURL(facebookURL as URL)) {
//            UIApplication.shared.openURL(facebookURL as URL)
//        } else {
//
//            guard let webpageURL = NSURL(string: "http://facebook.com/262951807595060/") else {
//                return
//            }
//
//            UIApplication.shared.openURL(webpageURL as URL)
//        }
//
//    }
}
