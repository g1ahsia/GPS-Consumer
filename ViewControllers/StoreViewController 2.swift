//
//  StoreViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/15.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import WebKit
//import SafariServices

class StoreViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
//    var mainImage : UIImage?
    var name : String?
    var desc : String?
    var address : String?
    var phoneNumber : String?

    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor .green
        return imageView
    }()
        
    var nameView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = MYTLE
        label.font = UIFont(name: "NotoSansTC-Medium", size: 28)
        return label
    }()
        
    var descView : UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = MYTLE
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor(red: 6/255, green: 11/255, blue: 5/255, alpha: 1)
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()

    var addressLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.textColor = MYTLE
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        return textLabel
    }()
    
    var phoneLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.textColor = MYTLE
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        return textLabel
    }()

    var more : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("更多好藥坊據點", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var webView: WKWebView = {
        let web = WKWebView.init(frame: UIScreen.main.bounds)
        let url = URL.init(string: "https://www.google.com/maps/d/u/0/embed?mid=1JxhMHeOjPXYVbNwUheNe_2Sogq8MwMn6&ll=23.674595369197746%2C120.57739473712506&z=7")!
        let request = URLRequest.init(url: url)
        web.load(request)
        web.navigationDelegate = self
        web.uiDelegate = self  //must have this

//        let url = URL(string: "https://www.google.com/maps/d/u/0/embed?mid=1JxhMHeOjPXYVbNwUheNe_2Sogq8MwMn6&ll=23.674595369197746%2C120.57739473712506&z=7")!
//        web.load(URLRequest(url: url))
        web.allowsBackForwardNavigationGestures = true

        return web
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SNOW
        title = "藥局介紹"
        view.addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainImageView)
        mainScrollView.addSubview(nameView)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(addressLabel)
        mainScrollView.addSubview(phoneLabel)
        mainScrollView.addSubview(more)
        
        NetworkManager.fetchStore(id: 2) { (store) in
            print("store is ", store)
            DispatchQueue.main.async {
                self.nameView.text = store.name
                self.descView.text = store.description
                self.mainImageView.downloaded(from: store.imageUrl!) {
                    self.setupLayout()
                }
                if ((store.address) != nil) {
                    self.address = "藥局地址：" +  store.address!
                }
                if ((self.phoneNumber) != nil) {
                    self.phoneNumber = "藥局電話" + store.phoneNumber!
                }
            }
        }

    }
    
    private func setupLayout() {
//        if let image = mainImage {
//            mainImageView.image = image
//        }
        if let name = name {
            nameView.text = name
        }
        if let desc = desc {
            descView.text = desc
        }
        if let address = address {
            addressLabel.text = address
        }
        if let phoneNumber = phoneNumber {
            phoneLabel.text = phoneNumber
        }

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: (mainImageView.image?.size.height)!/(mainImageView.image?.size.width)!).isActive = true
//        mainImageView.addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
//
//        mainImageView.addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))

        nameView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 24).isActive = true
        nameView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 17).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        addressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        addressLabel.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 17).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        phoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 17).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true

        more.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        more.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 17).isActive = true
        more.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        more.heightAnchor.constraint(equalToConstant: 44).isActive = true
        more.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true

    }
    
    @objc private func moreButtonTapped(sender: UIButton!) {
        let controller = UIViewController()
//        self.view.addSubview(self.webView)

        controller.view.addSubview(self.webView)
        controller.modalPresentationStyle = .fullScreen
        controller.title = "好藥坊據點"
//        present(controller, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func webView(_ webView: WKWebView,
                   createWebViewWith configuration: WKWebViewConfiguration,
                   for navigationAction: WKNavigationAction,
                   windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
          if url.description.lowercased().range(of: "http://") != nil ||
            url.description.lowercased().range(of: "https://") != nil ||
            url.description.lowercased().range(of: "mailto:") != nil {
            UIApplication.shared.openURL(url)
          }
        }
      return nil
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }


}
