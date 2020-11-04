//
//  ForgetPasswordViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/23.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class ForgetPasswordViewController: UIViewController {

    var hintView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.clipsToBounds = true;
        textView.text = "請輸入您註冊時的手機號碼，\n我們將寄送新的密碼給您。"
        return textView
    }()

    lazy var accountTableView : UITableView = {
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

    var send : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送出", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘記密碼"
        view.backgroundColor = SNOW

        view.addSubview(hintView)
        view.addSubview(accountTableView)
        view.addSubview(send)

        setupLayout()
    }
    private func setupLayout() {

        hintView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
        hintView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        hintView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28).isActive = true

        accountTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        accountTableView.topAnchor.constraint(equalTo: hintView.bottomAnchor, constant: 30).isActive = true
        accountTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        accountTableView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        send.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        send.topAnchor.constraint(equalTo: accountTableView.bottomAnchor, constant: 30).isActive = true
        send.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        send.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }
    @objc private func sendButtonTapped(sender: UIButton!) {
        let cell0 = accountTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell

        if (!GlobalVariables.validateMobile(phoneNum: cell0.answerField.text)) {
            GlobalVariables.showAlert(title: title, message: ERR_INCORRECT_PHONE_NUMBER_FORMAT, vc: self)
            return
        }
        GlobalVariables.showAlertWithOptions(title: MSG_TITLE_NEW_PASSWORD, message: MSG_NEW_PASSWORD, confirmString: MSG_RE_LOGIN, vc: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension ForgetPasswordViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.answerField.delegate = self
        switch indexPath.row {
            case 0:
                cell.field = "手機號碼："
                cell.placeholder = "請填寫手機號碼"
                cell.fieldType = FieldType.Number
            default:
                cell.field = ""
        }
        cell.layoutSubviews()
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    
}

extension ForgetPasswordViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}
