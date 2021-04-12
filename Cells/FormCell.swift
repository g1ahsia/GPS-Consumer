//
//  FormCell.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/7.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class FormCell: UITableViewCell {
    var field : String?
    var answer : String?
    var placeholder : String?
    var fieldType : FieldType?
    
    var fieldLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.sizeToFit()
        textLabel.textColor = BLACKAlpha40
        return textLabel
    }()
    
    var answerField : UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textField.textAlignment = .left
        textField.autocapitalizationType = .none;
        textField.returnKeyType = .done
        textField.textColor = MYTLE
        textField.isEnabled = true
        return textField
    }()

    var arrowRight : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_right_sm_grey")
        imageView.isHidden = true
        return imageView
    }()
    
    var arrowDown : UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: " arw_down_sm_grey")
        imageView.isHidden = true
        return imageView
    }()
    
    let datePicker : UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.isHidden = true
        if #available(iOS 14, *) {
//            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
            }
        return datePicker
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier : reuseIdentifier)
        self.contentView.addSubview(fieldLabel)
        self.contentView.addSubview(answerField)
        self.contentView.addSubview(arrowRight)
        self.contentView.addSubview(arrowDown)
        self.contentView.addSubview(datePicker)
        self.backgroundColor = .clear
        answerField.delegate = self
        answerField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        if let field = field {
            fieldLabel.text = field
        }
        if let answer = answer {
            answerField.text = answer
        }
        if let placeholder = placeholder {
            answerField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: BLACKAlpha40])
        }
        if let type = fieldType {
            switch type {
            case FieldType.Text:
                break
            case FieldType.Password:
                answerField.isSecureTextEntry = true
                break
            case FieldType.Selection:
                answerField.isUserInteractionEnabled = false
                arrowDown.isHidden = false
                break
            case FieldType.Number:
                answerField.keyboardType = .numberPad
                break
            case FieldType.Email:
                answerField.keyboardType = .emailAddress
                break
            case FieldType.DisplayOnly:
                answerField.isUserInteractionEnabled = false
                break
            case FieldType.Navigate:
                answerField.isUserInteractionEnabled = false
                arrowRight.isHidden = false
                break
            case FieldType.Date:
                answerField.isUserInteractionEnabled = false
                answerField.isHidden = true
                arrowRight.isHidden = true
                answerField.inputView = datePicker
                datePicker.isHidden = false
                datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
                print("date of birth", answer)
                if (answer != nil) {
                    datePicker.setDate(from: answer!, format: "yyyy/MM/dd")
                }
                break
            }
        }

        fieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        fieldLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        fieldLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        arrowRight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowRight.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        
        answerField.leftAnchor.constraint(equalTo: fieldLabel.rightAnchor, constant: 8).isActive = true
        answerField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        answerField.widthAnchor.constraint(equalToConstant: 260).isActive = true
        answerField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        arrowDown.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowDown.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true

        datePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        if #available(iOS 14, *) {
            datePicker.leftAnchor.constraint(equalTo: fieldLabel.rightAnchor).isActive = true
        }
        else {
            datePicker.leftAnchor.constraint(equalTo: fieldLabel.rightAnchor, constant: -40).isActive = true
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        answer = textField.text
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            answerField.text = "\(year)/\(month)/\(day)"
            answerField.endEditing(true)
            answerField.sendActions(for: .editingChanged)
            answer = "\(year)/\(month)/\(day)"
        }
    }
}

extension FormCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}

extension UIDatePicker {
   func setDate(from string: String, format: String, animated: Bool = true) {
      let formater = DateFormatter()
      formater.dateFormat = format
      let date = formater.date(from: string) ?? Date()
      setDate(date, animated: animated)
   }
}
