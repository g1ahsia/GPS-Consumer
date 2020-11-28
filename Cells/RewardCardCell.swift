
import Foundation
import UIKit


class RewardCardCell: UITableViewCell {
    var mainImage : UIImage?
    var name : String?
    var store : String?
    var templateId : Int!
    var threshold : Int!
    var currentPoint : Int!
    var pointsCollectionViewHeightConstraint: NSLayoutConstraint?
    var inactiveImage : UIImage!
    var activeImage : UIImage!
    var isUsed : Bool?
    
    lazy var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16;
        return imageView
    }()
    
    var nameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textColor = UIColor .white
        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 28)
        return textLabel
    }()

    var storeLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textColor = UIColor .white
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 11)
        return textLabel
    }()

    lazy var pointsCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PointCell.self, forCellWithReuseIdentifier: "point")
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()
    
    var validityLabel : UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "NotoSansTC-Bold", size: 13)
        label.text = "可兌換"
        label.alpha = 1.0
        return label
    }()
    
    var validityLabel_not : UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "NotoSansTC-Bold", size: 13)
        label.text = "無法兌換"
        label.alpha = 0.5
        return label
    }()


    var validityBackground : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14;
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear

        self.addSubview(mainImageView)
        mainImageView.addSubview(pointsCollectionView)
        mainImageView.addSubview(nameLabel)
        mainImageView.addSubview(storeLabel)
        mainImageView.addSubview(validityBackground)
        mainImageView.addSubview(validityLabel)
        mainImageView.addSubview(validityLabel_not)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let name = name {
            nameLabel.text = name
        }
        if let store = store {
            storeLabel.text = store
        }
        var collectionViewHeight = CGFloat(0)
        var cellSize = CGFloat(0)
        
        if let templateId = templateId {
            switch templateId {
            case 1:
                mainImage = #imageLiteral(resourceName: "flower-points-card")
                inactiveImage = #imageLiteral(resourceName: "flower-check-inactive")
                activeImage = #imageLiteral(resourceName: "flower-check-active")
                break
            case 2:
                mainImage = #imageLiteral(resourceName: "rainbow-points-card")
                inactiveImage = #imageLiteral(resourceName: "rainbow-check-inactive")
                activeImage = #imageLiteral(resourceName: "rainbow-check-active")
            case 3:
                mainImage = #imageLiteral(resourceName: "present-points-card")
                inactiveImage = #imageLiteral(resourceName: "present-check-inactive")
                activeImage = #imageLiteral(resourceName: "present-check-active")
            case 4:
                mainImage = #imageLiteral(resourceName: "smile-points-card")
                inactiveImage = #imageLiteral(resourceName: "smile-check-inactive")
                activeImage = #imageLiteral(resourceName: "smile-check-active")
            default:
                break
            }
        }
        if let image = mainImage {
            mainImageView.image = image
        }

        if let threshold = threshold {
            if (threshold <= 5) {
                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
                collectionViewHeight = 2 * cellSize + 5
            }
            else if (threshold <= 10) {
                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
                collectionViewHeight = 2 * cellSize + 5
            }
            else if (threshold == 15) {
                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
                collectionViewHeight = 3 * cellSize + 2 * 5
            }
            else if (threshold == 20) {
                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
                collectionViewHeight = 4 * cellSize + 3 * 5
            }
            else if (threshold == 25) {
                cellSize = (UIScreen.main.bounds.width - 72 - 4*10) / 5
                collectionViewHeight = 5 * cellSize + 4 * 5
            }
            else if (threshold == 30) {
                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
                collectionViewHeight = 3 * cellSize + 2 * 5
            }
            else if (threshold == 35) {
                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
                collectionViewHeight = 4 * cellSize + 3 * 5
            }
            else if (threshold == 40) {
                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
                collectionViewHeight = 4 * cellSize + 3 * 5
            }
            else if (threshold == 45) {
                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
                collectionViewHeight = 5 * cellSize + 4 * 5
            }
            else if (threshold == 50) {
                cellSize = (UIScreen.main.bounds.width - 72 - 9*10) / 10
                collectionViewHeight = 5 * cellSize + 4 * 5
            }
            pointsCollectionViewHeightConstraint?.isActive = false
            pointsCollectionViewHeightConstraint = pointsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
            pointsCollectionViewHeightConstraint?.isActive = true
            pointsCollectionView.reloadData()
        }
        
        if let isUsed = isUsed {
            if (isUsed) {
                validityBackground.widthAnchor.constraint(equalToConstant: 65).isActive = true
                validityBackground.backgroundColor = SHUTTLE_GREY
                validityLabel.isHidden = false
                validityLabel_not.isHidden = true
                validityLabel.text = "已兌換"
            }
            else {
                if (threshold != currentPoint) {
                    validityBackground.widthAnchor.constraint(equalToConstant: 78).isActive = true
                    validityBackground.backgroundColor = .clear
                    validityLabel.isHidden = true
                    validityLabel_not.isHidden = false
                }
                else {
                    validityBackground.widthAnchor.constraint(equalToConstant: 78).isActive = true
                    validityBackground.backgroundColor = ATLANTIS_GREEN
                    validityLabel.isHidden = false
                    validityLabel_not.isHidden = true
                    validityLabel.text = "可兌換"
                }
            }
        }

        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: pointsCollectionView.bottomAnchor, constant: 20).isActive = true

        storeLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        storeLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 33).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        pointsCollectionView.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        pointsCollectionView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 72).isActive = true
        pointsCollectionView.rightAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: -16).isActive = true
                
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        if (threshold <= 5) {
            layout.sectionInset = UIEdgeInsets(top: (collectionViewHeight - cellSize)/2, left: 0, bottom: 0, right: 0)
        }
        else {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        layout.minimumInteritemSpacing = 10 // 點數左右間距
        layout.minimumLineSpacing = 5 // 點數上下間距
        pointsCollectionView.collectionViewLayout = layout
        
        validityBackground.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
        validityBackground.rightAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: -16).isActive = true
        validityBackground.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        validityLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        validityLabel.centerYAnchor.constraint(equalTo: validityBackground.centerYAnchor).isActive = true
        validityLabel.centerXAnchor.constraint(equalTo: validityBackground.centerXAnchor).isActive = true
        
        validityLabel_not.heightAnchor.constraint(equalToConstant: 28).isActive = true
        validityLabel_not.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
        validityLabel_not.rightAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: -16).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RewardCardCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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

