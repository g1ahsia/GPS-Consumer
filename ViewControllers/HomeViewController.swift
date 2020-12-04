//
//  HomeViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/19.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {

    var missions = [Mission]()
    
    var merchandises = [Merchandise]()
    
    var coupons = [Coupon]()
    
    var rewardCards = [RewardCard]()
    
    var HOME_INDICATOR = ((UIDevice.current.userInterfaceIdiom == .phone) ? 34 : 0);

    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 4, height: UIScreen.main.bounds.height - 160 - 49));

    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let buttonSelector = UIView()
    
    var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_gps_horizontal")
        return imageView
    }()
    
    var storeLabel : UITextField = {
        let label =  UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = UIFont(name: "PingFangTC-Medium", size: 28)
        label.textColor = ATLANTIS_GREEN
//        label.text = "松仁藥局"
        return label
    }()

    var separator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor .black
        view.alpha = 0.2
        return view
    }()
    
    var separator1 = UIView()
    var separator2 = UIView()
    var separator3 = UIView()

    lazy var menuView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 8
        return view
    }()
    
    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 4, height: 0)
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    lazy var merchandiseCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let itemWidth = (UIScreen.main.bounds.width - 49) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 180 * itemWidth/163 + 70)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 9
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MerchandiseCell.self, forCellWithReuseIdentifier: "merchandise")
        collectionView.backgroundColor = .clear
        return collectionView
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
    
    lazy var missionTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MissionCell.self, forCellReuseIdentifier: "mission")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var rewardCardTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RewardCardCell.self, forCellReuseIdentifier: "rewardCard")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var prescription : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_albums"), for: .normal)
        button.addTarget(self, action: #selector(prescriptionButtonTapped), for: .touchUpInside)
        return button
    }()

    var prescriptionLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 11)
        textLabel.sizeToFit()
        textLabel.textColor = ATLANTIS_GREEN
        textLabel.text = "領取處方"
        return textLabel
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if (self.missionTableView.indexPathForSelectedRow != nil) {
            self.missionTableView.deselectRow(at: self.missionTableView.indexPathForSelectedRow!, animated: true)
        }
        
        NetworkManager.fetchStore(id: STOREID) { (fetchedStore) in
            DispatchQueue.main.async {
                self.storeLabel.text = fetchedStore.name
            }
        }
        
        NetworkManager.fetchCoupons() { (coupons) in
            self.coupons = coupons
            DispatchQueue.main.async {
                self.couponTableView.reloadData()
            }
        }
        
        NetworkManager.fetchRewardCards() { (rewardCards) in
            self.rewardCards = rewardCards
            DispatchQueue.main.async {
                self.rewardCardTableView.reloadData()
            }
        }
        
        NetworkManager.fetchMerchandisesByKeyword(keyword : "") { (merdhandises) in
            self.merchandises = merdhandises
            DispatchQueue.main.async {
                self.merchandiseCollectionView.reloadData()
            }
        }
        
        NetworkManager.fetchMissions() { (missions) in
            self.missions = missions
            DispatchQueue.main.async {
                self.missionTableView.reloadData()
            }
        }


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        
        var image = UIImage(#imageLiteral(resourceName: "ic_fill_add"))
        image = image.withRenderingMode(.alwaysOriginal)
        let add = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(self.prescriptionButtonTapped)) //
        self.navigationItem.rightBarButtonItem  = add

//        missions = [Mission.init(id: 1, name: "臉書粉絲團按讚", desc: "凡到好藥坊粉絲團點讚，將獲得優惠券乙張", imageUrl: "")]
        
        separator1.backgroundColor = UIColor .black
        separator1.alpha = 0.2
        separator1.translatesAutoresizingMaskIntoConstraints = false
        separator1.isHidden = true
        
        separator2.backgroundColor = UIColor .black
        separator2.alpha = 0.2
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        separator3.backgroundColor = UIColor .black
        separator3.alpha = 0.2
        separator3.translatesAutoresizingMaskIntoConstraints = false

        separator.backgroundColor = UIColor .black
        separator.alpha = 0.2
        separator.translatesAutoresizingMaskIntoConstraints = false

        separator.backgroundColor = UIColor .black
        separator.alpha = 0.2
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(prescription)
        view.addSubview(prescriptionLabel)
        view.addSubview(menuView)
        view.addSubview(mainScrollView)
        view.addSubview(logoImageView)
        view.addSubview(storeLabel)
        view.addSubview(separator)

        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("優惠券", for: .normal)
        button1.setTitleColor(UIColor(red: 89/255, green: 98/255, blue: 105/255, alpha: 1), for: .normal)
        button1.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button1.backgroundColor = .clear
        button1.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("集點卡", for: .normal)
        button2.setTitleColor(UIColor(red: 89/255, green: 98/255, blue: 105/255, alpha: 1), for: .normal)
        button2.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button2.backgroundColor = .clear
        button2.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.setTitle("商品", for: .normal)
        button3.setTitleColor(UIColor(red: 89/255, green: 98/255, blue: 105/255, alpha: 1), for: .normal)
        button3.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button3.backgroundColor = .clear
        button3.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.setTitle("任務", for: .normal)
        button4.setTitleColor(UIColor(red: 89/255, green: 98/255, blue: 105/255, alpha: 1), for: .normal)
        button4.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button4.backgroundColor = .clear
        button4.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        buttonSelector.frame = CGRect(x: 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/4, height: 36)
        buttonSelector.backgroundColor = SNOW
        buttonSelector.layer.cornerRadius = 8
        buttonSelector.layer.borderWidth = 0.5
        buttonSelector.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.04).cgColor
        buttonSelector.layer.shadowColor = UIColor .black.cgColor;
        buttonSelector.layer.shadowOpacity = 0.12;
        buttonSelector.layer.shadowOffset = CGSize(width: 0, height: 3)
        buttonSelector.layer.shadowRadius = 10 / 2.0;

        menuView.addSubview(separator1)
        menuView.addSubview(separator2)
        menuView.addSubview(separator3)
        menuView.addSubview(buttonSelector)
        menuView.addSubview(button1)
        menuView.addSubview(button2)
        menuView.addSubview(button3)
        menuView.addSubview(button4)

        mainScrollView.addSubview(couponTableView)
        mainScrollView.addSubview(rewardCardTableView)
        mainScrollView.addSubview(merchandiseCollectionView)
        mainScrollView.addSubview(missionTableView)

        mainScrollView.delegate = self
        couponTableView.separatorColor = .clear
        rewardCardTableView.separatorColor = .clear
        missionTableView.tableFooterView = UIView(frame: .zero)

        setupLayout()
        
        
//        NetworkManager.fetchCoupons() { (coupons) in
//            self.coupons = coupons
//            DispatchQueue.main.async {
//                self.couponTableView.reloadData()
//            }
//        }
//        coupons = [Coupon.init(id: 1, templateId: 1, store: "松仁藥局", name: "保養品七折優惠", remark: "每人限選一項商品", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: ""), Coupon.init(id: 2, templateId: 2, store: "松仁藥局", name: "成人口罩\n八折優惠", remark: "每人最多可買 2 盒", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: ""), Coupon.init(id: 3, templateId: 3, store: "松仁藥局", name: "成人口罩\n五折優惠", remark: "每人最多可買 2 盒", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: "")]
        
        
//        rewardCards = [RewardCard.init(id: 1, templateId: 1, name: "綠之集點卡", threshold: 15, currentPoint: 12,             description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 2, templateId: 2, name: "彩虹集點卡", threshold: 20, currentPoint: 20, description: "集滿點數即可兌換商品，好獎等你來拿。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 3, templateId: 3, name: "禮物集點卡", threshold: 15, currentPoint: 3, description: "集滿點數即可兌換商品，等你來拿", rewards: [1, 12, 13, 14]), RewardCard.init(id: 4, templateId: 4, name: "微笑集點卡", threshold: 30, currentPoint: 25, description: "集滿點數可以玩抽抽樂。", rewards: [1, 12, 13, 14])]
    }
    
    private func setupLayout() {
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 53).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 87).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        storeLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 16).isActive = true
        storeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        storeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        prescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        prescription.centerYAnchor.constraint(equalTo: storeLabel.centerYAnchor).isActive = true
        
        prescriptionLabel.topAnchor.constraint(equalTo: prescription.bottomAnchor, constant: -5).isActive = true
        prescriptionLabel.centerXAnchor.constraint(equalTo: prescription.centerXAnchor).isActive = true

        separator.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 8).isActive = true
        separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 52).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 30).isActive = true

        menuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        menuView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        menuView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        button1.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/4).isActive = true
        button1.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button1.leftAnchor.constraint(equalTo: menuView.leftAnchor).isActive = true
        
        button2.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/4).isActive = true
        button2.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button2.leftAnchor.constraint(equalTo: button1.rightAnchor).isActive = true

        button3.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/4).isActive = true
        button3.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button3.leftAnchor.constraint(equalTo: button2.rightAnchor).isActive = true

        button4.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier:   1/4).isActive = true
        button4.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        button4.leftAnchor.constraint(equalTo: button3.rightAnchor).isActive = true
        
        separator1.leftAnchor.constraint(equalTo: button1.rightAnchor).isActive = true
        separator1.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 9).isActive = true
        separator1.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator1.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        separator2.leftAnchor.constraint(equalTo: button2.rightAnchor).isActive = true
        separator2.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 9).isActive = true
        separator2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator2.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        separator3.leftAnchor.constraint(equalTo: button3.rightAnchor).isActive = true
        separator3.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 9).isActive = true
        separator3.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator3.heightAnchor.constraint(equalToConstant: 18).isActive = true

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 20).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        couponTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        couponTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        couponTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        couponTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true

        rewardCardTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        rewardCardTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor, constant: UIScreen.main.bounds.width * 1).isActive = true
        rewardCardTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rewardCardTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true

        merchandiseCollectionView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        merchandiseCollectionView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor, constant: UIScreen.main.bounds.width * 2).isActive = true
        merchandiseCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        merchandiseCollectionView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true

        missionTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        missionTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor, constant: UIScreen.main.bounds.width * 3).isActive = true
        missionTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        missionTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor).isActive = true
        
        var localTimeZoneIdentifier: String {
            return TimeZone.current.identifier
        }
        
        print(localTimeZoneIdentifier)

    }
    
    @objc private func menuButtonTapped(sender: UIButton!) {
        if (sender == button1) {
            print("button Action 1", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/4, height: 36)
            separator1.isHidden = true
            separator2.isHidden = false
            separator3.isHidden = false

        }
        else if (sender == button2) {
            print("button Action 2", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2 + buttonSelector.frame.size.width + 2, y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/4, height: 36)
            separator1.isHidden = true
            separator2.isHidden = true
            separator3.isHidden = false

        }
        else if (sender == button3) {
            print("button Action 3", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2 + 2*(buttonSelector.frame.size.width + 2), y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/4, height: 36)
            separator1.isHidden = false
            separator2.isHidden = true
            separator3.isHidden = true

        }
        else {
            print("button Action 4", sender.buttonType)
            mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 3, y: 0), animated: true)
            buttonSelector.frame = CGRect(x: 2 + 3*(buttonSelector.frame.size.width + 2), y: 2, width: (UIScreen.main.bounds.width - 40 - 10)/4, height: 36)
            separator1.isHidden = false
            separator2.isHidden = false
            separator3.isHidden = true
        }
    }
    
    @objc private func prescriptionButtonTapped() {
        let messageComposeVC = MessageComposeViewController()
        messageComposeVC.messageType = MessageType.Prescription
        messageComposeVC.role = Role.Consumer
        if #available(iOS 13.0, *) {
            messageComposeVC.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(messageComposeVC, animated: true) {
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == couponTableView) {
            return 200 * (UIScreen.main.bounds.width - 20 * 2)/335 + 10
        }
        else if (tableView == missionTableView) {
            return 110
        }
        else if (tableView == rewardCardTableView) {
            let threshold = rewardCards[indexPath.row].threshold
            var heightOfPointCollectionView = CGFloat(0.0)
            var mainHeight = CGFloat(0.0)
            var gapHeight = CGFloat(0.0)
            if (threshold <= 5) {
                mainHeight = 2 * (UIScreen.main.bounds.width - 72 - 4*10) / 5
                gapHeight = CGFloat(5)
            }
            else if (threshold <= 10) {
                mainHeight = 2 * (UIScreen.main.bounds.width - 72 - 4*10) / 5
                gapHeight = CGFloat(5)
            }
            else if (threshold == 15) {
                mainHeight = 3 * (UIScreen.main.bounds.width - 72 - 4*10) / 5
                gapHeight = 2 * CGFloat(5)
            }
            else if (threshold == 20) {
                mainHeight = 4 * (UIScreen.main.bounds.width - 72 - 4*10) / 5
                gapHeight = 3 * CGFloat(5)
            }
            else if (threshold == 25) {
                mainHeight = 5 * (UIScreen.main.bounds.width - 72 - 4*10) / 5
                gapHeight = 4 * CGFloat(5)
            }
            else if (threshold == 30) {
                mainHeight = 3 * (UIScreen.main.bounds.width - 72 - 9*10) / 10
                gapHeight = 2 * CGFloat(5)
            }
            else if (threshold == 35) {
                mainHeight = 4 * (UIScreen.main.bounds.width - 72 - 9*10) / 10
                gapHeight = 3 * CGFloat(5)
            }
            else if (threshold == 40) {
                mainHeight = 4 * (UIScreen.main.bounds.width - 72 - 9*10) / 10
                gapHeight = 3 * CGFloat(5)
            }
            else if (threshold == 45) {
                mainHeight = 5 * (UIScreen.main.bounds.width - 72 - 9*10) / 10
                gapHeight = 4 * CGFloat(5)
            }
            else if (threshold == 50) {
                mainHeight = 5 * (UIScreen.main.bounds.width - 72 - 9*10) / 10
                gapHeight = 4 * CGFloat(5)
            }
            heightOfPointCollectionView =  mainHeight + gapHeight
            return 72 + heightOfPointCollectionView + 20 + 10 // 10 px gap

        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == couponTableView) {
            return coupons.count
        }
        else if (tableView == missionTableView) {
            return missions.count
        }
        else if (tableView == rewardCardTableView) {
            return rewardCards.count
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == couponTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "coupon", for: indexPath) as! CouponCell
            cell.selectionStyle = .none
            cell.id = coupons[indexPath.row].id
            cell.store = coupons[indexPath.row].store
            cell.name = coupons[indexPath.row].name
            cell.remark = coupons[indexPath.row].remark
            cell.templateId = coupons[indexPath.row].templateId
            cell.imageUrl = coupons[indexPath.row].imageUrl
            cell.isUsed = false
            cell.layoutSubviews()
            cell.setImage()
            
//            if (indexPath.row == 1) {
//                cell.mainImage = #imageLiteral(resourceName: "Banner-2")
//            }
            return cell
        }
        else if (tableView == missionTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mission", for: indexPath) as! MissionCell
//            cell.mainImage = #imageLiteral(resourceName: "Facebook Mission")
            cell.imageUrl = missions[indexPath.row].imageUrl
            cell.name = missions[indexPath.row].name
            cell.desc = missions[indexPath.row].desc
            cell.mainImage = #imageLiteral(resourceName: "img_holder")
            cell.layoutSubviews()
            cell.setImage()
            return cell

        }
        else if (tableView == rewardCardTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCard", for: indexPath) as! RewardCardCell
            cell.selectionStyle = .none
            cell.name = rewardCards[indexPath.row].name
            cell.store = rewardCards[indexPath.row].store
            cell.templateId = rewardCards[indexPath.row].templateId
            cell.threshold = rewardCards[indexPath.row].threshold
            cell.currentPoint = rewardCards[indexPath.row].currentPoint
            cell.isUsed = false
            cell.layoutSubviews()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == couponTableView) {
            let cell = couponTableView .cellForRow(at: indexPath) as! CouponCell
            let couponVC = CouponDetailViewController()
            couponVC.id = coupons[indexPath.row].id
            couponVC.imageUrl = coupons[indexPath.row].imageUrl
            couponVC.store = coupons[indexPath.row].store
            couponVC.name = coupons[indexPath.row].name
            couponVC.remark = coupons[indexPath.row].remark
            couponVC.desc = coupons[indexPath.row].description
            couponVC.templateId = coupons[indexPath.row].templateId
            couponVC.mainImage = cell.mainImage
            self.navigationController?.pushViewController(couponVC, animated: true)
        }
        else if (tableView == missionTableView) {
            let cell = missionTableView .cellForRow(at: indexPath) as! MissionCell
            let missionDetailVC = MissionDetailViewController()
            missionDetailVC.mainImage = cell.mainImage
            missionDetailVC.name = missions[indexPath.row].name
            missionDetailVC.desc = missions[indexPath.row].desc
            if (indexPath.row == 0) {
                missionDetailVC.isFacebook = true
            }
            else {
                missionDetailVC.isFacebook = false
            }

            self.navigationController?.pushViewController(missionDetailVC, animated: true)
        }
        else if (tableView == rewardCardTableView) {
            let rewardCardVC = RewardCardDetailViewController()
            rewardCardVC.id = rewardCards[indexPath.row].id
            rewardCardVC.name = rewardCards[indexPath.row].name
            rewardCardVC.store = "松仁藥局"
            rewardCardVC.templateId = rewardCards[indexPath.row].templateId
            rewardCardVC.threshold = rewardCards[indexPath.row].threshold
            rewardCardVC.currentPoint = rewardCards[indexPath.row].currentPoint
            rewardCardVC.desc = rewardCards[indexPath.row].description
            rewardCardVC.merchandises = rewardCards[indexPath.row].merchandises
            self.navigationController?.pushViewController(rewardCardVC, animated: true)
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == mainScrollView) {
                print("hehe", scrollView.contentOffset.x)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == mainScrollView) {
            if (scrollView.contentOffset.x == 0) {
                self.menuButtonTapped(sender: button1)
            }
            else if (scrollView.contentOffset.x == UIScreen.main.bounds.width) {
                self.menuButtonTapped(sender: button2)
            }
            else if (scrollView.contentOffset.x == UIScreen.main.bounds.width * 2) {
                self.menuButtonTapped(sender: button3)
            }
            else {
                self.menuButtonTapped(sender: button4)
            }

        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchandises.count;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchandise", for: indexPath) as! MerchandiseCell
        cell.name = merchandises[indexPath.row].name
        cell.price = "NT$\(Int(merchandises[indexPath.row].price))"
        cell.imageUrls = merchandises[indexPath.row].imageUrls
        cell.setImage()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let merchandiseDetailVC = MerchandiseDetailViewController()
        merchandiseDetailVC.name = merchandises[indexPath.row].name
        merchandiseDetailVC.remark = merchandises[indexPath.row].remark
//        merchandiseDetailVC.mainImage = nil
        merchandiseDetailVC.imageUrls = merchandises[indexPath.row].imageUrls
        merchandiseDetailVC.price = "NT$\(Int(merchandises[indexPath.row].price))"
        merchandiseDetailVC.desc = merchandises[indexPath.row].description
        self.navigationController?.pushViewController(merchandiseDetailVC, animated: true)
    }
}
