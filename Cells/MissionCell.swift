
import Foundation
import UIKit

class MissionCell: UITableViewCell {
    var mainImage : UIImage?
    var name : String?
    var desc : String?
    var imageUrl : String?
        
    var mainImageView : ImageLoader = {
        var imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "img_holder")
        return imageView
    }()
    
    var nameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Bold", size: 20)
        textLabel.textColor = .black
        textLabel.clipsToBounds = true
        return textLabel
    }()

    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled  = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 13)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true

        return textView
    }()
    
    var arrow : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(mainImageView)
        self.addSubview(nameLabel)
        self.addSubview(descView)
        self.addSubview(arrow)

    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        if let image = mainImage {
            mainImageView.image = image
        }
        if let name = name {
            nameLabel.text = name
        }
        if let desc = desc {
            descView.text = desc
        }
        if let imageUrl = imageUrl {
//            if let strUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              if let imgUrl = URL(string: imageUrl) {
                mainImageView.loadImageWithUrl(imgUrl) // call this line for getting image to yourImageView
            }
        }
        
        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        descView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 8).isActive = true
        descView.topAnchor.constraint(equalTo: self.topAnchor, constant: 61).isActive = true
        descView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setImage() {
//        if (imageUrl != nil) {
//            DispatchQueue.main.async {
//                let jsonUrlString = self.imageUrl
//                guard let url = URL(string: jsonUrlString!) else { return }
//                URLSession.shared.dataTask(with: url) { (data, response, err) in
//                    guard let data = data else { return }
//
//                    if err == nil {
//                        let image = UIImage(data: data)
//
//                        DispatchQueue.main.async {
//                            self.mainImage = image
//                            self.mainImageView.image = self.mainImage
//                        }
//                    }
//                }.resume()
//            }
//        }
//    }

}
