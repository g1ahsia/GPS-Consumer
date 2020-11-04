//
//  CouponUsageHistoryViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/22.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class CouponUsageHistoryViewController: UIViewController {
    var coupons = [Coupon]()

    lazy var couponTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200 * (UIScreen.main.bounds.width - 20 * 2)/335 + 10
//        tableView.backgroundColor = UIColor .green
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(CouponCell.self, forCellReuseIdentifier: "coupon")
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
        title = "優惠券使用紀錄"

        view.addSubview(couponTableView)
        setupLayout()
        couponTableView.separatorColor = .clear
        couponTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))

//        NetworkManager.fetchCoupons() { (coupons) in
//            self.coupons = coupons
//            DispatchQueue.main.async {
//                self.couponTableView.reloadData()
//            }
//        }
        coupons = [Coupon.init(id: 1, templateId: 1, store: "松仁藥局", name: "保養品七折優惠", remark: "每人限選一項商品", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: ""), Coupon.init(id: 2, templateId: 2, store: "松仁藥局", name: "成人口罩\n八折優惠", remark: "每人最多可買 2 盒", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: ""), Coupon.init(id: 3, templateId: 3, store: "松仁藥局", name: "成人口罩五折優惠", remark: "每人最多可買 2 盒", description: "兌換商品時，請向店員出示此畫面。\n\n已使用的兌換券無法再被使用。若因使用者誤觸而變成『已兌換』，同樣無法使用。", imageUrl: "")]

    }
    private func setupLayout() {
        couponTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        couponTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        couponTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        couponTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension CouponUsageHistoryViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coupon", for: indexPath) as! CouponCell
        cell.name = coupons[indexPath.row].name
        cell.store = coupons[indexPath.row].store
        cell.remark = coupons[indexPath.row].remark
        cell.templateId = coupons[indexPath.row].templateId
        cell.isUsed = true
        cell.layoutSubviews()
        return cell
    }

}
