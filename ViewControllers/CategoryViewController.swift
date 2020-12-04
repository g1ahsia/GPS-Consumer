//
//  CategoryViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/6/27.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    
    var categories = [Category]()
    
    var gpsCategoryCellEntries = [Category]()
    
    var storeCategoryCellEntries = [Category]()

    var selectedLevel = 0
    
    var selectedCell = CategoryCell()
    
    var merchandiseSearchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "關鍵字搜尋"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.setShowsCancelButton(false, animated: true)
        return searchBar
    }()

    lazy var categoryTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "category")
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        return tableView
    }()
    
    var search : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("確定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "商品類別"
        categoryTableView.tableFooterView = UIView(frame: .zero)
        
        merchandiseSearchBar.delegate = self
        view.addSubview(merchandiseSearchBar)
        view.addSubview(categoryTableView)
        view.addSubview(search)
        categories = [Category.init(id: 1, name: "好藥坊獨特商品", level: 1, nextLevel:
                        [Category.init(id: 3, name: "醫學美容", level: 2, nextLevel: [
                            Category.init(id: 13, name: "清潔 / 卸妝", level: 3, nextLevel: [
                                Category.init(id: 18, name: "卸妝乳 / 油 / 凝露", level: 4, nextLevel: []),
                                Category.init(id: 19, name: "臉部去角質", level: 4, nextLevel: []),
                                Category.init(id: 20, name: "洗面乳 / 慕斯", level: 4, nextLevel: [])
                            ]),
                            Category.init(id: 14, name: "面膜 / 凍膜", level: 3, nextLevel: []),
                            Category.init(id: 15, name: "抗敏 / 抗痘", level: 3, nextLevel: []),
                            Category.init(id: 16, name: "醫美保養", level: 3, nextLevel: []),
                            Category.init(id: 17, name: "特惠組 / 體驗組", level: 3, nextLevel: [])
                        ]),
                        Category.init(id: 4, name: "保健食品", level: 2, nextLevel: []),
                        Category.init(id: 5, name: "醫療用品", level: 2, nextLevel: []),
                        Category.init(id: 6, name: "口腔護理", level: 2, nextLevel: []),
                        Category.init(id: 7, name: "美容小物", level: 2, nextLevel: []),
                        Category.init(id: 8, name: "婦幼用品", level: 2, nextLevel: []),
                        Category.init(id: 9, name: "植萃保養", level: 2, nextLevel: [])
                    ]),
                    Category.init(id: 2, name: "松仁藥局商品", level: 1, nextLevel:[
                        Category.init(id: 10, name: "醫學美容", level: 2, nextLevel: []),
                        Category.init(id: 11, name: "保健食品", level: 2, nextLevel: []),
                        Category.init(id: 12, name: "醫療用品", level: 2, nextLevel: [])
                        ])
                    ]
        
        NetworkManager.fetchCategories() { (categories) in
            if (categories.count > 0) {
                self.gpsCategoryCellEntries = [categories[0]]
                self.storeCategoryCellEntries = [categories[1]]
                DispatchQueue.main.async {
                    self.categoryTableView.reloadData()
                }
            }
        }
        setupLayout()
        
        hideKeyboardWhenTappedOnView()
    }
    
    @objc private func searchButtonTapped() {
        search.isUserInteractionEnabled = false
        let searchResultVC = SearchResultViewController()
        NetworkManager.fetchMerchandisesByCategory(Id: selectedCell.category.id) { (merchandises) in
            DispatchQueue.main.async {
                searchResultVC.merchandises = merchandises
                self.navigationController?.pushViewController(searchResultVC, animated: true)
                self.search.isUserInteractionEnabled = true
            }
        }
    }
    
    private func setupLayout() {
        
        merchandiseSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        merchandiseSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        merchandiseSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        merchandiseSearchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true

        categoryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoryTableView.topAnchor.constraint(equalTo: merchandiseSearchBar.bottomAnchor, constant: 34).isActive = true
        categoryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        categoryTableView.bottomAnchor.constraint(equalTo: search.topAnchor, constant: -20).isActive = true
        
        search.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        search.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        search.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true

    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == categoryTableView) {
            if (section == 0) {
                return gpsCategoryCellEntries.count
            }
            else {
                return storeCategoryCellEntries.count
            }
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryCell
            cell.selectionStyle = .none
            cell.category = gpsCategoryCellEntries[indexPath.row]
            cell.selectedLevel = selectedLevel
            cell.nextLevel = gpsCategoryCellEntries[indexPath.row].nextLevel
            cell.layoutSubviews()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryCell
            cell.selectionStyle = .none
            cell.category = storeCategoryCellEntries[indexPath.row]
            cell.selectedLevel = selectedLevel
            cell.nextLevel = storeCategoryCellEntries[indexPath.row].nextLevel
            cell.layoutSubviews()
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search.alpha = 1.0
        search.isEnabled = true

        if (indexPath.section == 0) {
            selectedCell = tableView.cellForRow(at: indexPath) as! CategoryCell
            selectedCell.arrow.isHidden = true

            selectedLevel = selectedCell.category.level // 紀錄選擇的是哪一個level
            var indicesToBeRemoved = [Int]() // 儲存將被移除的index清單
            // traverse 目前table顯示的清單
            for index in 0..<gpsCategoryCellEntries.count {
                let category = gpsCategoryCellEntries[index]
                
                // 如果該category的level 大於或等於選擇的level，除了被選擇的那個category之外，其餘都從table刪除
                if (category.level >= selectedLevel &&
                    category.id != selectedCell.category.id) {
                    indicesToBeRemoved.append(index)
                }
            }
            
            // 執行刪除table item的動作
            gpsCategoryCellEntries = gpsCategoryCellEntries
            .enumerated()
            .filter { !indicesToBeRemoved.contains($0.offset) }
            .map { $0.element }
            

            // 把被選擇的category其中的nextLevel categories加入到table中
            for nextLevelCategory in selectedCell.category.nextLevel {
                gpsCategoryCellEntries.append(nextLevelCategory)
            }
            
            // 重新整理table
//            categoryTableView.reloadData()
            categoryTableView.reloadSections([0], with: .fade)
            
            // 找出被選擇的category目前在table所在的位置，手動選擇它讓它打勾勾
            let selectedIndex = gpsCategoryCellEntries.firstIndex(where: {$0.id == selectedCell.category.id})
            tableView.selectRow(at: IndexPath(row: selectedIndex!, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        else {
            selectedCell = tableView.cellForRow(at: indexPath) as! CategoryCell
            selectedLevel = selectedCell.category.level // 紀錄選擇的是哪一個level
            var indicesToBeRemoved = [Int]() // 儲存將被移除的index清單
            // traverse 目前table顯示的清單
            for index in 0..<storeCategoryCellEntries.count {
                let category = storeCategoryCellEntries[index]
                
                // 如果該category的level 大於或等於選擇的level，除了被選擇的那個category之外，其餘都從table刪除
                if (category.level >= selectedLevel &&
                    category.id != selectedCell.category.id) {
                    indicesToBeRemoved.append(index)
                }
            }
            
            // 執行刪除table item的動作
            storeCategoryCellEntries = storeCategoryCellEntries
            .enumerated()
            .filter { !indicesToBeRemoved.contains($0.offset) }
            .map { $0.element }
            

            // 把被選擇的category其中的nextLevel categories加入到table中
            for nextLevelCategory in selectedCell.category.nextLevel {
                storeCategoryCellEntries.append(nextLevelCategory)
            }
            
            // 重新整理table
//            categoryTableView.reloadData()
            categoryTableView.reloadSections([1], with: .fade)
            
            // 找出被選擇的category目前在table所在的位置，手動選擇它讓它打勾勾
            let selectedIndex = storeCategoryCellEntries.firstIndex(where: {$0.id == selectedCell.category.id})
            tableView.selectRow(at: IndexPath(row: selectedIndex!, section: 1), animated: false, scrollPosition: UITableView.ScrollPosition.none)

        }
    }
}

extension CategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchResultVC = SearchResultViewController()
//        self.navigationController?.pushViewController(searchResultVC, animated: true)
        let searchResultVC = SearchResultViewController()
        NetworkManager.fetchMerchandisesByKeyword(keyword: merchandiseSearchBar.text ?? "") { (merchandises) in
            DispatchQueue.main.async {
                searchResultVC.merchandises = merchandises
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
        }
    }
}
