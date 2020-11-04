//
//  RewardCardsViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//
import Foundation
import UIKit

class RewardCardsViewController: UIViewController {
    var rewardCards = [RewardCard]()
    var heightOfRewardCard = CGFloat(0)
    var id : Int?
    var purpose : ConsumerSearchPurpose?
    var points : Int?

    lazy var rewardCardTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RewardCardCell.self, forCellReuseIdentifier: "rewardCard")
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW

        view.addSubview(rewardCardTableView)
        rewardCardTableView.tableFooterView = UIView(frame: .zero)
        rewardCardTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        setupLayout()

        //        NetworkManager.fetchRewardCards() { (rewardCards) in
        //            self.rewardCards = rewardCards
        //            DispatchQueue.main.async {
        //                self.rewardCardTableView.reloadData()
        //            }
        //        }
        if (purpose == ConsumerSearchPurpose.LookUp) {
            title = "商品兌換紀錄"
            rewardCards = [RewardCard.init(id: 1, templateId: 1, name: "綠之集點卡", threshold: 15, currentPoint: 15, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 2, templateId: 2, name: "彩虹集點卡", threshold: 20, currentPoint: 20, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 3, templateId: 3, name: "禮物集點卡", threshold: 15, currentPoint: 15, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 4, templateId: 4, name: "微笑集點卡", threshold: 30, currentPoint: 30, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14])]
        }
        else {
            title = "請選擇一張集點卡"
            rewardCards = [RewardCard.init(id: 1, templateId: 1, name: "綠之集點卡", threshold: 15, currentPoint: 9, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 2, templateId: 2, name: "彩虹集點卡", threshold: 20, currentPoint: 15, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 3, templateId: 3, name: "禮物集點卡", threshold: 15, currentPoint: 10, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14]), RewardCard.init(id: 4, templateId: 4, name: "微笑集點卡", threshold: 30, currentPoint: 10, description: "集滿點數即可兌換商品。", rewards: [1, 12, 13, 14])]
        }

    }
    private func setupLayout() {
        rewardCardTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rewardCardTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        rewardCardTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rewardCardTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension RewardCardsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardCards.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        heightOfRewardCard = 72 + heightOfPointCollectionView + 20 + 10 // 10 px gap
        return heightOfRewardCard
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCard", for: indexPath) as! RewardCardCell
        cell.selectionStyle = .none
        cell.name = rewardCards[indexPath.row].name
        cell.store = "松仁藥局"
        cell.templateId = rewardCards[indexPath.row].templateId
        cell.threshold = rewardCards[indexPath.row].threshold
        cell.currentPoint = rewardCards[indexPath.row].currentPoint
        if (purpose == ConsumerSearchPurpose.LookUp) {
            cell.isUsed = true
        }
        else {
            cell.isUsed = false
        }
        cell.layoutSubviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let rewardCardVC = RewardCardDetailViewController()
//        rewardCardVC.name = rewardCards[indexPath.row].name
//        rewardCardVC.store = "松仁藥局"
//        rewardCardVC.templateId = rewardCards[indexPath.row].templateId
//        rewardCardVC.threshold = rewardCards[indexPath.row].threshold
//        rewardCardVC.currentPoint = rewardCards[indexPath.row].currentPoint
//        rewardCardVC.desc = rewardCards[indexPath.row].description
//        self.navigationController?.pushViewController(rewardCardVC, animated: true)
        
        if (purpose == ConsumerSearchPurpose.LookUp) {
        }
        else {
            GlobalVariables.showAlertWithOptions(title: MSG_TITLE_SEND_POINTS, message: "發送\(self.points!)點到此張集點卡？", confirmString: MSG_SEND_POINTS, vc: self) {
                self.navigationController?.popViewController(animated: true)
            }
        }

    }

}
