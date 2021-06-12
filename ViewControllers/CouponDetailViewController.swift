//
//  CouponDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/26.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class CouponDetailViewController: UIViewController {
    var id : Int?
    var imageUrl : String?
    var mainImage : UIImage?
    var store : String?
    var name : String?
    var remark : String?
    var desc : String?
    var templateId : Int?
    var heightOfCoupon = CGFloat(0)

    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    lazy var couponTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CouponCell.self, forCellReuseIdentifier: "coupon")
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
        return tableView
    }()

    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = UIColor(red: 6/255, green: 11/255, blue: 5/255, alpha: 1)
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.textAlignment = .center
        return textView
    }()
    
    var use : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("立刻兌換", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
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
        
        self.view.backgroundColor = SNOW
        title = "優惠券"
        self.view.addSubview(mainScrollView)

        mainScrollView.addSubview(couponTableView)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(use)
        mainScrollView.addSubview(hintLabel)
        setupLayout()

        couponTableView.separatorColor = .clear
    }
    
    private func setupLayout() {
        if let desc = desc {
            descView.text = desc
        }
        heightOfCoupon = 200 * (UIScreen.main.bounds.width - 20 * 2)/335 + 10

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        couponTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 20).isActive = true
        couponTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        couponTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        couponTableView.heightAnchor.constraint(equalToConstant: heightOfCoupon).isActive = true

        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: couponTableView.bottomAnchor, constant: 30).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true

        use.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        use.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 40).isActive = true
        use.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        use.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true
        
        hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: use.bottomAnchor, constant: 10).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true

    }
    @objc private func addButtonTapped() { }
    
    @objc private func useButtonTapped(sender: UIButton!) {
        let cell = couponTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! CouponCell

        GlobalVariables.showAlertWithOptions(title: MSG_TITLE_USE_COUPON, message: "立即兌換『" + cell.name! + "』", confirmString: MSG_TITLE_USE, vc: self) {
            print("確認要兌換")
            NetworkManager.useCoupon(id: cell.id!) { (result) in
                DispatchQueue.main.async {
                    if (result["status"] as! Int == 1) {
                        print("used ", result)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else if (result["status"] as! Int == -1) {
                        GlobalVariables.showAlert(title: MSG_TITLE_USE_COUPON, message: ERR_CONNECTING, vc: self)
                    }
                    else {
                        GlobalVariables.showAlert(title: MSG_TITLE_USE_COUPON, message: ERR_USING_COUPON, vc: self)
                    }
                }
            }
        }
    }
}

extension CouponDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCoupon
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coupon", for: indexPath) as! CouponCell
        cell.selectionStyle = .none
        cell.id = id
        cell.imageUrl = imageUrl
        cell.store = store
        cell.name = name
        cell.remark = remark
        cell.templateId = templateId
        cell.isUsed = false
        cell.layoutSubviews()
//        cell.setImage()
        return cell
    }

}

