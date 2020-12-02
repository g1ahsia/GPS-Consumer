//
//  ImageCell.swift
//  TableInTable
//
//  Created by Michał Kaczmarek on 26.09.2017.
//  Copyright © 2017 Michał Kaczmarek. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    var imageUrl = String()

    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "prescription")
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor .red.cgColor
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.yellow
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(mainImageView)
        addConstraintsWithFormat("V:|-0-[v0]-0-|", views: mainImageView)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: mainImageView)

    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        imageUrl = ""
        mainImageView.image = #imageLiteral(resourceName: "prescription")
    }

    func setImage() {
        DispatchQueue.main.async {
            let jsonUrlString = self.imageUrl
            guard let url = URL(string: jsonUrlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else { return }

                if err == nil {
                    let image = UIImage(data: data)

                    DispatchQueue.main.async {
                        self.mainImageView.image = image
                        self.setupView()
                    }
                }
            }.resume()
        }
    }

}
