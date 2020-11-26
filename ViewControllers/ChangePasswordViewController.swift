//
//  ChangePasswordViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/31.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit


class ChangePasswordViewController: UIViewController {
    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        tableView.backgroundColor = .clear
        return tableView
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
        button.alpha = 0.5
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SNOW
        title = "更改密碼"
        view.addSubview(infoTableView)
        view.addSubview(save)
        infoTableView.tableFooterView = UIView(frame: .zero)
        setupLayout()

        hideKeyboardWhenTappedOnView()
    }
    private func setupLayout() {
        infoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        save.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        save.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 30).isActive = true
        save.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        save.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @objc private func saveButtonTapped(sender: UIButton!) {
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        
//        if (!GlobalVariables.validateMobile(phoneNum: cell0.answerField.text)) {
//            GlobalVariables.showAlert(title: title, message: ERR_INCORRECT_PHONE_NUMBER_FORMAT, vc: self)
//            return
//        }

        if (cell1.answerField.text != cell2.answerField.text &&
            cell1.answerField.text != "" &&
            cell2.answerField.text != "") {
            GlobalVariables.showAlert(title: title, message: ERR_PASSWORD_NOT_THE_SAME, vc: self)
            return
        }
        
        NetworkManager.changePassword(oldPassword: cell0.answerField.text!, newPassword: cell1.answerField.text!) { (result) in
            DispatchQueue.main.async {
                if (result["status"] as! Int == 1) {
                        self.navigationController?.popToRootViewController(animated: true)
                }
                else if (result["status"] as! Int == -1) {
                    GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                }
                else {
                    GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                }
            }
        }
    }
}

extension ChangePasswordViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.field = "舊密碼："
                cell.placeholder = "請輸入舊密碼"
                cell.fieldType = FieldType.Password
                break
            case 1:
                cell.field = "新密碼："
                cell.placeholder = "請輸入新密碼"
                cell.fieldType = FieldType.Password
                break
            case 2:
                cell.field = "確認新密碼："
                cell.placeholder = "再次輸入新密碼"
                cell.fieldType = FieldType.Password
                break
            default:
                cell.field = ""
        }
        cell.layoutSubviews()
        cell.answerField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
            default:
                break
            }
    }
    
    @objc func textFieldDidChange() {
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        
        if (cell0.answerField.text != "" &&
            cell1.answerField.text != "" &&
            cell2.answerField.text != "") {
            save.alpha = 1.0
            save.isEnabled = true
        }
        else {
            save.alpha = 0.5
            save.isEnabled = false
        }
    }

}

