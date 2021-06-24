//
//  AccountDetailViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/15.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class AccountDetailViewController: UIViewController {
//    var id : Int?
    var consumer = Consumer.init(id: 0, name: "", mobilePhone: "", homePhone: "", dateOfBirth: nil, serialNumber: "", email: "", address: "", gender: 0, storeId: 0, tags: [])

    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        tableView.backgroundColor = .clear
        return tableView
    }()

//    var datePicker : UIDatePicker = {
//        var picker = UIDatePicker()
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        picker.backgroundColor = .white
//        picker.datePickerMode = .date
//        picker.alpha = 0
//        picker.setValue(MYTLE, forKeyPath: "textColor")
//        return picker
//    }()
    
    lazy var sexPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()
    
    var save : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("確認修改", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
//        button.alpha = 0.50
        return button
    }()

    var blackCover : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    var versionLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 14)
        textLabel.sizeToFit()
        textLabel.textColor = MYTLE
        return textLabel
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "修改個人資料"
//        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        view.addSubview(infoTableView)
        view.addSubview(versionLabel)
        view.addSubview(save)
        infoTableView.tableFooterView = UIView(frame: .zero)
        view.addSubview(blackCover)
//        view.addSubview(datePicker)
        view.addSubview(sexPickerView)
                
        let tapOnBlackCover = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blackCover.addGestureRecognizer(tapOnBlackCover)
        setupLayout()
        
        hideKeyboardWhenTappedOnView()
    }
    
    private func setupLayout() {
        NetworkManager.fetchConsumer() { (fetchedConsumer) in
            print("no such consumer", fetchedConsumer)
            self.consumer = fetchedConsumer
            DispatchQueue.main.async {
                self.infoTableView.reloadData()
                print("1111")
            }
        }
        infoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 450).isActive = true
                
        blackCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blackCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        blackCover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        blackCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sexPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        sexPickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        sexPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        save.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        save.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 30).isActive = true
        save.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        save.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func saveButtonTapped(sender: UIButton!) {
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        let cell4 = infoTableView.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! FormCell
        let cell5 = infoTableView.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! FormCell
        let cell6 = infoTableView.cellForRow(at: NSIndexPath(row: 6, section: 0) as IndexPath) as! FormCell

        consumer.dateOfBirth = cell1.answer
        
        print("dateOfBirth", consumer.dateOfBirth!)
        
        let parameters: [String: Any] = [
            "name": cell0.answerField.text!,
            "dateOfBirth": consumer.dateOfBirth!,
            "serialNumber": cell2.answerField.text!,
            "homePhone": cell4.answerField.text!,
            "email": cell5.answerField.text!,
            "address": cell6.answerField.text!,
            "gender": consumer.gender!,
        ]
        
        NetworkManager.editInfo(parameters: parameters) { (status) in
            DispatchQueue.main.async {
                if (status == 1) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else if (status == -1) {
                    GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                }
                else {
                    GlobalVariables.showAlert(title: self.title, message: ERR_EDITING_INFO, vc: self)
                }
            }
        }

    }

//    @objc func dateChanged(_ sender: UIDatePicker) {
//        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
//        if let day = components.day, let month = components.month, let year = components.year {
//            print("\(day) \(month) \(year)")
//            let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
//            cell1.answer = "\(year)/\(month)/\(day)"
//            cell1.layoutSubviews()
//            consumer.dateOfBirth = "\(year)/\(month)/\(day)"
//        }
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        UIView .animate(withDuration: 0.3) {
            self.blackCover.alpha = 0
            self.sexPickerView.alpha = 0
//            self.datePicker.alpha = 0
        }
    }
}

extension AccountDetailViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2222")
        return 9

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("3333 ", consumer)

        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
//        cell.answerField.delegate = self

        switch indexPath.row {
            case 0:
                cell.field = "姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.Text
                cell.answer = consumer.name
                break
            case 1:
                cell.field = "出生日期："
                cell.placeholder = "請輸入出生日期"
                cell.fieldType = FieldType.Date
                cell.answer = consumer.dateOfBirth
                break
            case 2:
                cell.field = "身份證字號："
                cell.placeholder = "請填寫身份證字號"
                cell.fieldType = FieldType.Email
                cell.answer = consumer.serialNumber
                break
            case 3:
                cell.field = "手機號碼："
                cell.answer = consumer.mobilePhone
                cell.fieldType = FieldType.DisplayOnly
                break
            case 4:
                cell.field = "市話："
                cell.answer = consumer.homePhone
                cell.fieldType = FieldType.Text
                break
            case 5:
                cell.field = "電子郵件："
                cell.placeholder = "請填寫電子郵件"
                cell.fieldType = FieldType.Email
                cell.answer = consumer.email
                break
            case 6:
                cell.field = "地址："
                cell.placeholder = "請填寫住址"
                cell.fieldType = FieldType.Text
                cell.answer = consumer.address
                break
            case 7:
                cell.field = "性別："
                switch consumer.gender {
                case 1:
                    cell.answer = "男性"
                case 2:
                    cell.answer = "女性"
                default:
                    cell.answer = ""
                }
                cell.placeholder = "請選擇性別"
                cell.fieldType = FieldType.Selection
                break
            case 8:
                cell.field = "更改密碼"
                cell.fieldType = FieldType.Navigate
                break
            default:
                cell.field = ""
                break
        }
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 7:
                UIView .animate(withDuration: 0.3) {
                    self.blackCover.alpha = 0.5
                    self.sexPickerView.alpha = 1
                }
                self.view.endEditing(true)
                break
            case 8:
                let changePasswordVC = ChangePasswordViewController()
                changePasswordVC.role = Role.Consumer
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
                break
            default:
                UIView .animate(withDuration: 0.3) {
                    self.sexPickerView.alpha = 0
                }
                break
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if #available(iOS 14, *) {
            return 50
        }
        else {
            switch indexPath.row {
                case 1:
                    return 180
                default:
                    return 50
            }
        }
    }

}

extension AccountDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 2
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return "男性"
            }
            return "女性"
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell7 = infoTableView.cellForRow(at: NSIndexPath(row: 7, section: 0) as IndexPath) as! FormCell
        if row == 0 {
            cell7.answer = "男性"
        }
        else {
            cell7.answer = "女性"
        }
        consumer.gender = row+1
        print("pickerView didSelectRow")
        cell7.layoutSubviews()
        self.view.endEditing(true)
    }

}

extension AccountDetailViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text as Any)
//        datePicker.alpha = 0
        sexPickerView.alpha = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}
