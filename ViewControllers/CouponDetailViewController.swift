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
//        if let image = mainImage {
//            mainImageView.image = image
//        }
//        if let store = store {
//            storeLabel.text = store
//        }
//        if let name = name {
//            nameView.text = name
//        }
//        if let remark = remark {
//            remarkLabel.text = remark
//        }
        if let desc = desc {
            descView.text = desc
        }
//        if let templateId = templateId {
            
//            NetworkManager.fetchCouponTemplate(id: templateId) { (couponTemplate) in
//                DispatchQueue.main.async {
//                    let gradient = CAGradientLayer()
//                    gradient.frame = self.mainImageBackground.bounds
//                    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//                    gradient.cornerRadius = 16;
//                    gradient.colors = [UIColor(hexString: couponTemplate.gradientColorLeft).cgColor, UIColor(hexString: couponTemplate.gradientColorRight).cgColor]
//                    self.mainImageBackground.layer.insertSublayer(gradient, at: 0)
//
//                }
//            }
//            switch templateId {
//            case 1:
//                gradient.colors = [UIColor(hexString: "#4CD964").cgColor, UIColor(hexString: "#83EE9D").cgColor]
//                break
//            case 2:
//                gradient.colors = [UIColor(hexString: "#408BFC").cgColor, UIColor(hexString: "#74BFFE").cgColor]
//                break
//            case 3:
//                gradient.colors = [UIColor(hexString: "#A66EFA").cgColor, UIColor(hexString: "#D2A7FD").cgColor]
//                break
//            case 4:
//                gradient.colors = [UIColor(hexString: "#D12765").cgColor, UIColor(hexString: "#EA4F9E").cgColor]
//                break
//            case 5:
//                gradient.colors = [UIColor(hexString: "#FC7B1E").cgColor, UIColor(hexString: "#FEB240").cgColor]
//                break
//            default:
//                break
//            }
//        }
        heightOfCoupon = 200 * (UIScreen.main.bounds.width - 20 * 2)/335 + 10


        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

//        mainImageBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        mainImageBackground.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 40)).isActive = true
//        mainImageBackground.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 200/335).isActive = true
//        mainImageBackground.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 8).isActive = true
//
//        mainImageView.leftAnchor.constraint(equalTo: mainImageBackground.leftAnchor).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: mainImageBackground.topAnchor).isActive = true
//        mainImageView.rightAnchor.constraint(equalTo: mainImageBackground.rightAnchor).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: mainImageBackground.bottomAnchor).isActive = true
//
//        storeLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        storeLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
//        storeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
//
//        nameView.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        nameView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 33).isActive = true
//
//        remarkLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        remarkLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 166).isActive = true
//        remarkLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true

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
//        use.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: use.bottomAnchor, constant: 10).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true

    }
    @objc private func addButtonTapped() { }
    
    @objc private func useButtonTapped(sender: UIButton!) {
//        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
//            print("User click Approve button")
//        }))
//
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
//        let alert = UIAlertController(title: "兌換優惠券", message: "立即兌換『保養品七折優惠』", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//
////        alert.addTextField(configurationHandler: { textField in
////            textField.placeholder = "Input your name here..."
////        })
//
//        alert.addAction(UIAlertAction(title: "兌換", style: .default, handler: { action in
//                print("Your name:")
//        }))
//
//        self.present(alert, animated: true)
        let cell = couponTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! CouponCell

        GlobalVariables.showAlertWithOptions(title: MSG_TITLE_USE_COUPON, message: "立即兌換『" + cell.name! + "』", confirmString: MSG_TITLE_USE, vc: self) {
            print("確認要兌換")
            NetworkManager.useCoupon(id: cell.id!) { (result) in
                if (result["status"] as! Int == 1) {
                    print("used ", result)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async {
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
        cell.store = store
        cell.name = name
        cell.remark = remark
        cell.templateId = templateId
        cell.isUsed = false
        cell.mainImage = mainImage
        cell.layoutSubviews()
        return cell
    }

}

