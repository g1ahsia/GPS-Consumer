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
    var usedRewardCards = [UsedRewardCard]()
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
        if (purpose == ConsumerSearchPurpose.LookUp) {
            title = "商品兌換紀錄"
            
            NetworkManager.fetchUsedRewardCards { (rewardCards) in
                self.usedRewardCards = rewardCards
                DispatchQueue.main.async {
                    self.rewardCardTableView.reloadData()
                }
            }
        }
        else {
            title = "請選擇一張集點卡"
            NetworkManager.fetchConsumerRewardCards(id: id!) { (rewardCards) in
                self.rewardCards = rewardCards
                DispatchQueue.main.async {
                    self.rewardCardTableView.reloadData()
                }
            }
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
        if (purpose == ConsumerSearchPurpose.LookUp) {
            return usedRewardCards.count
        }
        else if (purpose == ConsumerSearchPurpose.SendPoints) {
            return rewardCards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var threshold = 0;
        if (purpose == ConsumerSearchPurpose.LookUp) {
            threshold = usedRewardCards[indexPath.row].withdrawPoint
        }
        else if (purpose == ConsumerSearchPurpose.SendPoints) {
            threshold = rewardCards[indexPath.row].threshold
        }
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
        if (purpose == ConsumerSearchPurpose.LookUp) {
            cell.name = usedRewardCards[indexPath.row].name
            cell.store = usedRewardCards[indexPath.row].store
            cell.templateId = usedRewardCards[indexPath.row].templateId
            cell.threshold = usedRewardCards[indexPath.row].withdrawPoint
            cell.currentPoint = usedRewardCards[indexPath.row].withdrawPoint
        }
        else if (purpose == ConsumerSearchPurpose.SendPoints) {
            cell.name = rewardCards[indexPath.row].name
            cell.store = rewardCards[indexPath.row].store
            cell.templateId = rewardCards[indexPath.row].templateId
            cell.threshold = rewardCards[indexPath.row].threshold
            cell.currentPoint = rewardCards[indexPath.row].currentPoint
        }
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
        else if (purpose == ConsumerSearchPurpose.SendPoints)
        {
            GlobalVariables.showAlertWithOptions(title: MSG_TITLE_SEND_POINTS, message: "發送\(self.points!)點到此張集點卡？", confirmString: MSG_SEND_POINTS, vc: self) { [self] in
                
                NetworkManager.depositForConsumer(consumerId: id!, rewardCardId: rewardCards[indexPath.row].id, points: self.points!, completionHandler: { (result) in
                    DispatchQueue.main.async {
                        if (result["status"] as! Int == 1) {
                            GlobalVariables.showAlert(title: MSG_TITLE_SEND_POINTS, message: MSG_SENT_POINTS, vc: self)
                            NetworkManager.fetchConsumerRewardCards(id: id!) { (rewardCards) in
                                self.rewardCards = rewardCards
                                DispatchQueue.main.async {
                                    self.rewardCardTableView.reloadData()
                                }
                            }
                        }
                        else if (result["status"] as! Int == -1) {
                            GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                        }
                        else {
                            GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                        }
                    }
                })
            }
        }

    }

}
