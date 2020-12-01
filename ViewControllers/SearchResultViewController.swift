//
//  SearchResultViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/21.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    var merchandises = [Merchandise]()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(merchandiseCollectionView)
        view.backgroundColor = SNOW
        title = "搜尋結果"
        setupLayout()
//        NetworkManager.fetchMerchandises() { (merdhandises) in
//            self.merchandises = merdhandises
//            DispatchQueue.main.async {
//                self.merchandiseCollectionView.reloadData()
//            }
//        }
    }
    
    private func setupLayout() {

        merchandiseCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        merchandiseCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        merchandiseCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        merchandiseCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchandises.count;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchandise", for: indexPath) as! MerchandiseCell
        cell.name = merchandises[indexPath.row].name
        cell.price = "\(merchandises[indexPath.row].price)"
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
        merchandiseDetailVC.price = "\(merchandises[indexPath.row].price)"
        merchandiseDetailVC.desc = merchandises[indexPath.row].description
        
        self.navigationController?.pushViewController(merchandiseDetailVC, animated: true)
    }
}
