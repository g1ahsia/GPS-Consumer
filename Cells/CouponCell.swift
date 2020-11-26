
import Foundation
import UIKit

class CouponCell: UITableViewCell {
//    var mainImage : UIImage?
    var imageUrl : String?
    var id : Int?
    var store : String?
    var name : String?
    var remark : String?
    var templateId : Int?
    var isUsed : Bool?

    var mainImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16;
        imageView.clipsToBounds = true;
        return imageView
    }()
    
    var mainImageBackground : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16;
        return view
    }()

    var storeLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textColor = UIColor .white
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 11)
        return textLabel
    }()
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont(name: "NotoSansTC-Medium", size: 28)
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        return textView
    }()
    
    var remarkLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textColor = UIColor .white
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 13)
        return textLabel
    }()
    
    var validityLabel : UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "NotoSansTC-Bold", size: 13)
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
        self.addSubview(mainImageBackground)
        mainImageBackground.addSubview(mainImageView)
        mainImageView.addSubview(storeLabel)
        mainImageView.addSubview(nameView)
        mainImageView.addSubview(remarkLabel)
        mainImageView.addSubview(validityBackground)
        mainImageView.addSubview(validityLabel)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
//        if let image = mainImage {
//            mainImageView.image = image
//        }
        if let imageUrl = imageUrl {
            mainImageView.downloaded(from: imageUrl) {
            }
        }
        if let id = id {
        }

        if let store = store {
            storeLabel.text = store
        }
        if let name = name {
            nameView.text = name
        }
        if let remark = remark {
            remarkLabel.text = remark
        }
        if let templateId = templateId {
            
            NetworkManager.fetchCouponTemplate(id: templateId) { (couponTemplate) in
                
                DispatchQueue.main.async {
                    let gradient = CAGradientLayer()
                    gradient.frame = self.mainImageBackground.bounds
                    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                    gradient.cornerRadius = 16;
                    gradient.colors = [UIColor(hexString: couponTemplate.gradientColorLeft).cgColor, UIColor(hexString: couponTemplate.gradientColorRight).cgColor]
                    self.mainImageBackground.layer.insertSublayer(gradient, at: 0)

                }
            }
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
        }
        if let isUsed = isUsed {
            if (isUsed) {
                validityBackground.widthAnchor.constraint(equalToConstant: 65).isActive = true
                validityBackground.backgroundColor = SHUTTLE_GREY
                validityLabel.text = "已兌換"
            }
            else {
                validityBackground.widthAnchor.constraint(equalToConstant: 78).isActive = true
                validityBackground.backgroundColor = ATLANTIS_GREEN
                validityLabel.text = "尚未兌換"
            }
        }

        mainImageBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainImageBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        mainImageBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        mainImageView.leftAnchor.constraint(equalTo: mainImageBackground.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: mainImageBackground.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: mainImageBackground.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: mainImageBackground.bottomAnchor).isActive = true
        
        storeLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        storeLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        nameView.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        nameView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 33).isActive = true
        
        remarkLabel.leftAnchor.constraint(equalTo: mainImageView.leftAnchor, constant: 16).isActive = true
        remarkLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 166).isActive = true
        remarkLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true

        validityBackground.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 16).isActive = true
        validityBackground.rightAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: -16).isActive = true
        validityBackground.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        validityLabel.centerYAnchor.constraint(equalTo: validityBackground.centerYAnchor).isActive = true
        validityLabel.centerXAnchor.constraint(equalTo: validityBackground.centerXAnchor).isActive = true
        validityLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
