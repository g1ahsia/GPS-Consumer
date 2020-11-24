//
//  RewardCardDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/21.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class RewardCardDetailViewController: UIViewController {
    var id : Int?
    var mainImage : UIImage?
    var templateId : Int!
    var name : String?
    var store : String?
    var threshold : Int!
    var currentPoint : Int!
    var desc : String?
    var pointsCollectionViewHeightConstraint: NSLayoutConstraint?
    var inactiveImage : UIImage!
    var activeImage : UIImage!
    var merchandises : [Merchandise]!
    var heightOfRewardCard = CGFloat(0)
    
    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
//    var mainImageView : UIImageView = {
//       var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 16;
//        imageView.clipsToBounds = true;
//        imageView.image = #imageLiteral(resourceName: "flower-points-card")
//        return imageView
//    }()
//
//    var nameLabel : UILabel = {
//        var textLabel = UILabel()
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        textLabel.backgroundColor = .clear
//        textLabel.textColor = UIColor .white
//        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 28)
//        return textLabel
//    }()
//
//    var storeLabel : UILabel = {
//        var textLabel = UILabel()
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        textLabel.backgroundColor = .clear
//        textLabel.textColor = UIColor .white
//        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 11)
//        return textLabel
//    }()
    
    lazy var rewardCardTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RewardCardCell.self, forCellReuseIdentifier: "rewardCard")
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
        
    var scan : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("掃描QR Code", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
//        button.alpha = 0.5
        return button
    }()
    
    var barcodeIcon : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " ic_barcode_scan_white")
        return imageView
    }()
    
    var hintLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = MYTLE
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
//    lazy var pointsCollectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.setCollectionViewLayout(layout, animated: true)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(PointCell.self, forCellWithReuseIdentifier: "point")
//        collectionView.backgroundColor = .clear
//        collectionView.isUserInteractionEnabled = false
//        return collectionView
//    }()
    
    lazy var merchandiseTableView : UITableView = {
        var tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.rowHeight = 110
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MissionCell.self, forCellReuseIdentifier: "mission")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var use : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("立刻兌換", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if (self.merchandiseTableView.indexPathForSelectedRow != nil) {
            self.merchandiseTableView.deselectRow(at: self.merchandiseTableView.indexPathForSelectedRow!, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SNOW
        title = "集點卡"
        view.addSubview(mainScrollView)

//        mainScrollView.addSubview(mainImageView)
//        mainImageView.addSubview(pointsCollectionView)
//        mainImageView.addSubview(nameLabel)
//        mainImageView.addSubview(storeLabel)
        mainScrollView.addSubview(rewardCardTableView)
        mainScrollView.addSubview(descView)
        mainScrollView.addSubview(scan)
        mainScrollView.addSubview(hintLabel)
        scan.addSubview(barcodeIcon)
        mainScrollView.addSubview(merchandiseTableView)
        mainScrollView.addSubview(use)

        merchandiseTableView.tableFooterView = UIView(frame: .zero)
        
//        NetworkManager.fetchMerchandises() { (merdhandises) in
//            self.merchandises = merdhandises
//            DispatchQueue.main.async {
//                self.hintLabel.text = "可兌換商品(\(self.merchandises.count)選1)"
//                self.merchandiseTableView.reloadData()
                self.setupLayout() // for calculating table height based on number of merchandises
//            }
//        }
        rewardCardTableView.separatorColor = .clear

    }
    
    private func setupLayout() {
        
        if (threshold > currentPoint) {
            use.alpha = 0.5
            use.isUserInteractionEnabled = false
        }
        else {
            use.alpha = 1.0
            use.isUserInteractionEnabled = true
        }
        if let desc = desc {
            descView.text = desc
        }
        if merchandises.count > 0 {
            self.merchandiseTableView.reloadData()
        }

//        if let name = name {
//            nameLabel.text = name
//        }
//        if let store = store {
//            storeLabel.text = store
//        }
//        if let templateId = templateId {
//            switch templateId {
//            case 1:
//                mainImage = #imageLiteral(resourceName: "flower-points-card")
//                inactiveImage = #imageLiteral(resourceName: "flower-check-inactive")
//                activeImage = #imageLiteral(resourceName: "flower-check-active")
//                break
//            case 2:
//                mainImage = #imageLiteral(resourceName: "rainbow-points-card")
//                inactiveImage = #imageLiteral(resourceName: "rainbow-check-inactive")
//                activeImage = #imageLiteral(resourceName: "rainbow-check-active")
//            case 3:
//                mainImage = #imageLiteral(resourceName: "present-points-card")
//                inactiveImage = #imageLiteral(resourceName: "present-check-inactive")
//                activeImage = #imageLiteral(resourceName: "present-check-active")
//            case 4:
//                mainImage = #imageLiteral(resourceName: "smile-points-card")
//                inactiveImage = #imageLiteral(resourceName: "smile-check-inactive")
//                activeImage = #imageLiteral(resourceName: "smile-check-active")
//            default:
//                break
//            }
//        }
//        if let image = mainImage {
//            mainImageView.image = image
//        }
//        var collectionViewHeight = CGFloat(0)
//        var cellSize = CGFloat(0)
//        if let threshold = threshold {
//            if (threshold <= 5) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
//                collectionViewHeight = 2 * cellSize + 5
//            }
//            else if (threshold <= 10) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
//                collectionViewHeight = 2 * cellSize + 5
//            }
//            else if (threshold == 15) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
//                collectionViewHeight = 3 * cellSize + 2 * 5
//            }
//            else if (threshold == 20) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
//                collectionViewHeight = 4 * cellSize + 3 * 5
//            }
//            else if (threshold == 25) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
//                collectionViewHeight = 5 * cellSize + 4 * 5
//            }
//            else if (threshold == 30) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
//                collectionViewHeight = 3 * cellSize + 2 * 5
//            }
//            else if (threshold == 35) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
//                collectionViewHeight = 4 * cellSize + 3 * 5
//            }
//            else if (threshold == 40) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
//                collectionViewHeight = 4 * cellSize + 3 * 5
//            }
//            else if (threshold == 45) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
//                collectionViewHeight = 5 * cellSize + 4 * 5
//            }
//            else if (threshold == 50) {
//                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
//                collectionViewHeight = 5 * cellSize + 4 * 5
//            }
//            pointsCollectionViewHeightConstraint?.isActive = false
//            pointsCollectionViewHeightConstraint = pointsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
//            pointsCollectionViewHeightConstraint?.isActive = true
//            pointsCollectionView.reloadData()
//        }

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

//        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 30).isActive = true
//        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: pointsCollectionView.bottomAnchor, constant: 20).isActive = true
//
//        nameLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 33).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
//
//        storeLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        storeLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
//        storeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
//
//        pointsCollectionView.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
//        pointsCollectionView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 72).isActive = true
//        pointsCollectionView.rightAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: -16).isActive = true

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
//        layout.itemSize = CGSize(width: cellSize, height: cellSize)
//
//        if (threshold <= 5) {
//            layout.sectionInset = UIEdgeInsets(top: (collectionViewHeight - cellSize)/2, left: 0, bottom: 0, right: 0)
//        }
//        else {
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 5
//        pointsCollectionView.collectionViewLayout = layout
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
        heightOfRewardCard = 72 + heightOfPointCollectionView + 20 + 10 // 10 px gap

                
        rewardCardTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 20).isActive = true
        rewardCardTableView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        rewardCardTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rewardCardTableView.heightAnchor.constraint(equalToConstant: heightOfRewardCard).isActive = true

        descView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descView.topAnchor.constraint(equalTo: rewardCardTableView.bottomAnchor, constant: 30).isActive = true
        descView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        scan.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        scan.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 40).isActive = true
        scan.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        scan.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true
        
        barcodeIcon.rightAnchor.constraint(equalTo: scan.rightAnchor, constant: -10).isActive = true
        barcodeIcon.centerYAnchor.constraint(equalTo: scan.centerYAnchor).isActive = true

//        use.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: scan.bottomAnchor, constant: 49).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        merchandiseTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        merchandiseTableView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 10).isActive = true
        merchandiseTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        merchandiseTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        merchandiseTableView.heightAnchor.constraint(equalToConstant: CGFloat(110 * merchandises.count)).isActive = true
        
        use.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        use.topAnchor.constraint(equalTo: merchandiseTableView.bottomAnchor, constant: 40).isActive = true
        use.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        use.heightAnchor.constraint(equalToConstant: 44).isActive = true
        use.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -60).isActive = true

    }
    
    @objc private func scanButtonTapped(sender: UIButton!) {
        let qrCodeScannerVC = QRCodeScannerViewController()
        qrCodeScannerVC.modalPresentationStyle = .fullScreen
        qrCodeScannerVC.rewardCardId = id
        qrCodeScannerVC.rewardCardDetailVC = self
        present(qrCodeScannerVC, animated: true)
        
//        let barcodeScannerVC = BarcodeScannerViewController()
//        present(barcodeScannerVC, animated: true)


    }
    
    @objc private func useButtonTapped(sender: UIButton!) {
        GlobalVariables.showAlertWithOptions(title: MSG_TITLE_USE_REWARD_CARD, message: "立即兌換\(self.name!)", confirmString: MSG_USE_REWARD_CARD, vc: self) {
            NetworkManager.withdraw(id: self.id!) { (result) in
                if (result["status"] as! Int == 1) {
                    DispatchQueue.main.async { [self] in
                        self.navigationController?.popViewController(animated: true)
                        GlobalVariables.showAlert(title: MSG_TITLE_WITHDRAW_REWARD_CARD, message: MSG_USED_REWARD_CARD, vc: self)
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        self.navigationController?.popViewController(animated: true)
                        GlobalVariables.showAlert(title: MSG_TITLE_WITHDRAW_REWARD_CARD, message: ERR_WITHDRAWING_REWARD_CARD, vc: self)
                    }
                }
            }
        }
    }

}

extension RewardCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return threshold;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "point", for: indexPath) as! PointCell
        if (indexPath.row <= currentPoint - 1) {
            cell.mainImage = activeImage
        }
        else if (indexPath.row == threshold - 1) {
            cell.mainImage = #imageLiteral(resourceName: "point-achieve")
        }
        else {
            cell.mainImage = inactiveImage
        }
        return cell
    }
}

extension RewardCardDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == rewardCardTableView) {
            return 1
        }
        else {
            return merchandises.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == rewardCardTableView) {
            return heightOfRewardCard
        }
        else {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == rewardCardTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCard", for: indexPath) as! RewardCardCell
            cell.selectionStyle = .none
            cell.name = name
            cell.store = "松仁藥局"
            cell.templateId = templateId
            cell.threshold = threshold
            cell.currentPoint = currentPoint
            cell.isUsed = false
            cell.layoutSubviews()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mission", for: indexPath) as! MissionCell
            let imageUrls = merchandises[indexPath.row].imageUrls
            if imageUrls.count > 0 {
                for case let imageURL in imageUrls {
                    cell.mainImageView.downloaded(from: imageURL) {
                    }
                }
            }
            cell.name = merchandises[indexPath.row].name
            cell.desc = merchandises[indexPath.row].remark
            cell.layoutSubviews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let merchandiseDetailVC = MerchandiseDetailViewController()
        merchandiseDetailVC.name = merchandises[indexPath.row].name
        merchandiseDetailVC.remark = merchandises[indexPath.row].remark
        merchandiseDetailVC.imageUrls = merchandises[indexPath.row].imageUrls
        merchandiseDetailVC.price = "\(merchandises[indexPath.row].price)"
        merchandiseDetailVC.desc = merchandises[indexPath.row].description
        self.navigationController?.pushViewController(merchandiseDetailVC, animated: true)
    }

}

