//
//  RegistrationViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/4.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class RegistrationViewController: UIViewController {
    var account = Account.init(mobilePhone: "", password: "", name: "", storeId: 0, homePhone: "", passcode: "")
    let steps = ["步驟1：帳號註冊", "步驟2：個人資料", "步驟3：選擇會員店", "步驟4：輸入認證碼", "步驟5：完成"]
    var allAreas = [Area]()
    var currentPage = 0
    var filteredAreas = [Area]()
    var passcodeWidth = (UIScreen.main.bounds.width - 2*20 - 5*9)/6
    let locationManager = CLLocationManager()
    var closestStore = NSDictionary()
    var selectedStoreID = -1
    var stepLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 20)
        textLabel.textAlignment = .center
        textLabel.textColor = ATLANTIS_GREEN
        return textLabel
    }()
    
    var mainScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 5, height: 500)
        scrollView.isScrollEnabled = true
//        scrollView.backgroundColor = UIColor .orange
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    lazy var accountTableView : UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        return tableView

    }()
    
    lazy var infoTableView : UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
//        tableView.allowsSelection = false
        tableView.register(FormCell.self, forCellReuseIdentifier: "form")
        return tableView

    }()

    lazy var storeTableView : UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(StoreCell.self, forCellReuseIdentifier: "store")
        return tableView

    }()
    
    var next0 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("下一步：個人資料", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    var next1 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("下一步：選擇會員店", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()

    var next2 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("下一步：輸入認證碼", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()

    var next3 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("確定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()

    var last1 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("上一步", for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = PATTENS_BLUE
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(lastButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var last2 : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("上一步", for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = PATTENS_BLUE
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(lastButtonTapped), for: .touchUpInside)
        return button
    }()

    var resend : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("重新寄送認證碼", for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = PATTENS_BLUE
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cancel : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("取消註冊會員", for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = PATTENS_BLUE
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    var done : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("立即登入", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    
    var datePicker : UIDatePicker = {
        var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.alpha = 0
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()
    
    lazy var sexPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()
    
    var blackCover : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    var hintLabel1 : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textColor = .black
        textLabel.clipsToBounds = false;
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.text = "系統已寄送確認碼至您的手機，\n請輸入認碼以啟用會員帳號。"
//        textLabel.backgroundColor = .red
        return textLabel
    }()
    
    var hintLabel2 : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.textColor = .black
        textLabel.clipsToBounds = false;
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        textLabel.text = "恭喜您完成註冊！"
        return textLabel
    }()

    var passcodeField : UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "NotoSansTC-Medium", size: 40)
        textField.textAlignment = .left
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.tintColor = .clear
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.textColor = MYTLE
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

//        textField.layer.borderColor = UIColor .green.cgColor
//        textField.layer.borderWidth = 1
        return textField
    }()

    var storeSearchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.setShowsCancelButton(false, animated: true)
        return searchBar
    }()
    
    var passcodeBackground1 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()
    
    var passcodeBackground2 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()
    
    var passcodeBackground3 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()

    var passcodeBackground4 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()

    var passcodeBackground5 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()
    
    var passcodeBackground6 : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PATTENS_BLUE
        view.layer.cornerRadius = 10
        return view
    }()
    
    var pageControl : UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.tintColor = ATLANTIS_GREEN
        pageControl.pageIndicatorTintColor = BLACKAlpha20
        pageControl.currentPageIndicatorTintColor = ATLANTIS_GREEN
//        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: UIControl.Event.valueChanged)
        return pageControl
    }()

    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 5, height: UIScreen.main.bounds.height - 160 - 49 - 34));

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIScreen.main.bounds.width == 375) {
            passcodeField.defaultTextAttributes.updateValue(35 * UIScreen.main.bounds.width/375, forKey: NSAttributedString.Key.kern)
            passcodeField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passcodeField.frame.height))
            passcodeField.leftViewMode = .always
        }
        else if (UIScreen.main.bounds.width == 414) {
            passcodeField.defaultTextAttributes.updateValue(41, forKey: NSAttributedString.Key.kern)
            passcodeField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: passcodeField.frame.height))
            passcodeField.leftViewMode = .always
        }
        passcodeField.delegate = self

        mainScrollView.addSubview(contentView)
        contentView.addSubview(accountTableView)
        contentView.addSubview(infoTableView)
        contentView.addSubview(storeSearchBar)
        contentView.addSubview(storeTableView)
        contentView.addSubview(next0)
        contentView.addSubview(next1)
        contentView.addSubview(next2)
        contentView.addSubview(next3)
        contentView.addSubview(last1)
        contentView.addSubview(last2)
        contentView.addSubview(resend)
        contentView.addSubview(cancel)
        contentView.addSubview(done)
        contentView.addSubview(hintLabel1)
        contentView.addSubview(hintLabel2)
        contentView.addSubview(passcodeBackground1)
        contentView.addSubview(passcodeBackground2)
        contentView.addSubview(passcodeBackground3)
        contentView.addSubview(passcodeBackground4)
        contentView.addSubview(passcodeBackground5)
        contentView.addSubview(passcodeBackground6)
        contentView.addSubview(passcodeField)

//        contentView.layer.borderColor = UIColor .green.cgColor
//        contentView.layer.borderWidth = 5
        
        accountTableView.tableFooterView = UIView(frame: .zero)
        infoTableView.tableFooterView = UIView(frame: .zero)
        storeTableView.tableFooterView = UIView(frame: .zero)
        

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        view.backgroundColor = SNOW
        view.addSubview(stepLabel)
        view.addSubview(mainScrollView)
        view.addSubview(pageControl)
        view .addSubview(blackCover)
//        view.addSubview(datePicker)
        view.addSubview(sexPickerView)

        title = "註冊會員"
        stepLabel.text = steps[currentPage]
        
        mainScrollView.delegate = self
        storeSearchBar.delegate = self
        
        let tapOnBlackCover = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blackCover.addGestureRecognizer(tapOnBlackCover)
        
        hideKeyboardWhenTappedOnView()
        
        setupLayout()
    }
    
    private func setupLayout() {
        stepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stepLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 118).isActive = true
        stepLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 25).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 44).isActive = true

        accountTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        accountTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        accountTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        accountTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        infoTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width * 1).isActive = true
        infoTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        storeSearchBar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width * 2).isActive = true
        storeSearchBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        storeSearchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        storeSearchBar.heightAnchor.constraint(equalToConstant: 48).isActive = true

        storeTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIScreen.main.bounds.width * 2).isActive = true
        storeTableView.topAnchor.constraint(equalTo: storeSearchBar.bottomAnchor).isActive = true
        storeTableView.bottomAnchor.constraint(equalTo: last2.topAnchor, constant: -30).isActive = true
        storeTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        next0.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        next0.topAnchor.constraint(equalTo: accountTableView.bottomAnchor, constant: 30).isActive = true
        next0.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width * 4).isActive = true
        next0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        last1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width).isActive = true
        last1.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 30).isActive = true
        last1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width * 3).isActive = true
        last1.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        next1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width).isActive = true
        next1.topAnchor.constraint(equalTo: last1.bottomAnchor, constant: 10).isActive = true
        next1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width * 3).isActive = true
        next1.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        last2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 2).isActive = true
        last2.bottomAnchor.constraint(equalTo: next2.topAnchor, constant: -10).isActive = true
        last2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width * 2).isActive = true
        last2.heightAnchor.constraint(equalToConstant: 44).isActive = true

        next2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 2).isActive = true
        next2.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20).isActive = true
        next2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width * 2).isActive = true
        next2.heightAnchor.constraint(equalToConstant: 44).isActive = true

        hintLabel1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        hintLabel1.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 67).isActive = true
        hintLabel1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width).isActive = true
        hintLabel1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passcodeBackground1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        passcodeBackground1.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground1.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground1.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        passcodeBackground2.leftAnchor.constraint(equalTo: passcodeBackground1.rightAnchor, constant: 9).isActive = true
        passcodeBackground2.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground2.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground2.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        passcodeBackground3.leftAnchor.constraint(equalTo: passcodeBackground2.rightAnchor, constant: 9).isActive = true
        passcodeBackground3.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground3.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground3.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        passcodeBackground4.leftAnchor.constraint(equalTo: passcodeBackground3.rightAnchor, constant: 9).isActive = true
        passcodeBackground4.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground4.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground4.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        passcodeBackground5.leftAnchor.constraint(equalTo: passcodeBackground4.rightAnchor, constant: 9).isActive = true
        passcodeBackground5.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground5.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground5.heightAnchor.constraint(equalToConstant: 96).isActive = true

        passcodeBackground6.leftAnchor.constraint(equalTo: passcodeBackground5.rightAnchor, constant: 9).isActive = true
        passcodeBackground6.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeBackground6.widthAnchor.constraint(equalToConstant: passcodeWidth).isActive = true
        passcodeBackground6.heightAnchor.constraint(equalToConstant: 96).isActive = true

        passcodeField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        passcodeField.topAnchor.constraint(equalTo: hintLabel1.bottomAnchor, constant: 30).isActive = true
        passcodeField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        passcodeField.heightAnchor.constraint(equalToConstant: 96).isActive = true

        next3.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        next3.topAnchor.constraint(equalTo: passcodeField.bottomAnchor, constant: 20).isActive = true
        next3.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width).isActive = true
        next3.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        resend.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        resend.topAnchor.constraint(equalTo: next3.bottomAnchor, constant: 10).isActive = true
        resend.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width).isActive = true
        resend.heightAnchor.constraint(equalToConstant: 44).isActive = true

        cancel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 3).isActive = true
        cancel.topAnchor.constraint(equalTo: resend.bottomAnchor, constant: 10).isActive = true
        cancel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20 - UIScreen.main.bounds.width).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
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
        
        
        hintLabel2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 4).isActive = true
        hintLabel2.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 67).isActive = true
        hintLabel2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        hintLabel2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        done.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20 + UIScreen.main.bounds.width * 4).isActive = true
        done.topAnchor.constraint(equalTo: hintLabel2.bottomAnchor, constant: 80).isActive = true
        done.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        done.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            cell1.answerField.text = "\(year)年\(month)月\(day)日"

        }
        textFieldDidChange()
    }

    
    @objc private func nextButtonTapped(sender: UIButton!) {
        if (sender == next0) {
            let cell0 = accountTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
            let cell1 = accountTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            let cell2 = accountTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
            
            if (!GlobalVariables.validateMobile(phoneNum: cell0.answerField.text)) {
                GlobalVariables.showAlert(title: title, message: ERR_INCORRECT_PHONE_NUMBER_FORMAT, vc: self)
                return
            }

            if (cell1.answerField.text != cell2.answerField.text &&
                cell1.answerField.text != "" &&
                cell2.answerField.text != "") {
                GlobalVariables.showAlert(title: title, message: ERR_PASSWORD_NOT_THE_SAME, vc: self)
                return
            }
            
            NetworkManager.findConsumer(mobile: cell0.answerField.text!, completionHandler: { (consumer) in
                print(consumer)
                DispatchQueue.main.async {
                    if (consumer.id != 0) {
                        GlobalVariables.showAlert(title: self.title, message: ERR_ACCOUNT_ALREADY_EXISTS, vc: self)
                        return
                    }
                    else {
                        self.account.mobilePhone = cell0.answerField.text!
                        self.account.password = cell1.answerField.text!
                        self.goToNextPage()
                    }
                }
            })

        }
        else if (sender == next1) {
            let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
            let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            if (cell0.answerField.text == "") {
                return
            }
            account.name = cell0.answerField.text!
            if (cell1.answerField.text != "") {
                account.homePhone = cell1.answerField.text!
            }

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            NetworkManager.fetchStores() { (areas) in
                print(areas)
                self.allAreas = areas
                self.filteredAreas = self.allAreas
                DispatchQueue.main.async {
                    self.storeTableView.reloadData()
                    
                    if CLLocationManager.locationServicesEnabled() {
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        self.locationManager.startUpdatingLocation()
                    }
                    else {
                        
                    }
                }
            }
            self.goToNextPage()
        }
        else if (sender == next2) {
            // Ask for Authorisation from the User.
            let parameters: [String: Any] =  ["mobilePhone" : account.mobilePhone,
                                              "name" : account.name,
                                              "password" : account.password,
                                              "storeId" : account.storeId,
                                              "homePhone" : account.homePhone]
            
            NetworkManager.signUp(parameters: parameters) { (status) in
                DispatchQueue.main.async {
                    if (status == 1) {
                        self.goToNextPage()
                        
//                        let uuid = UUID().uuidString
//                        let parameters: [String: Any] = [
//                            "deviceId" : uuid,
//                            "platform" : "ios"
//                        ]
//
//                        NetworkManager.setDevice(parameters: parameters) { (status) in
//                            if (status == 1) {
//                                print("device token added")
//                            }
//                        }
                    }
                    else {
                            GlobalVariables.showAlert(title: self.title, message: ERR_CREATING_ACCOUNT, vc: self)
                    }
                }
            }
        }
        else {
            account.passcode = passcodeField.text!
            let parameters: [String: Any] =  ["mobilePhone" : account.mobilePhone,
                                              "passcode" : account.passcode]
            
            NetworkManager.activate(parameters: parameters) { (status) in
                DispatchQueue.main.async {
                    if (status == 1) {
                        self.goToNextPage()
                        
                        let uuid = UUID().uuidString
                        let parameters: [String: Any] = [
                            "deviceId" : uuid,
                            "platform" : "ios"
                        ]
                        
                        NetworkManager.setDevice(parameters: parameters) { (status) in
                            if (status == 1) {
                                print("device token added")
                            }
                        }
                    }
                    else {
                            GlobalVariables.showAlert(title: self.title, message: ERR_ACTIVATING_ACCOUNT, vc: self)
                    }
                }
            }

        }

    }
    
    private func goToNextPage() {
        let newX = self.mainScrollView.contentOffset.x + UIScreen.main.bounds.width
        self.mainScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        self.currentPage += 1
        self.stepLabel.text = self.steps[currentPage]
        self.pageControl.currentPage = self.currentPage
    }
    
    @objc private func lastButtonTapped(sender: UIButton!) {
        let newX = mainScrollView.contentOffset.x - UIScreen.main.bounds.width
        mainScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        currentPage -= 1
        stepLabel.text = steps[currentPage]
        pageControl.currentPage = currentPage

    }
    
    @objc private func resendButtonTapped(sender: UIButton!) {
    }
    
    @objc private func cancelButtonTapped(sender: UIButton!) {
    }

    @objc private func doneButtonTapped(sender: UIButton!) {
        self.parent?.dismiss(animated: true) {
        }
        let parameters: [String: Any] = [
            "mobilePhone": account.mobilePhone,
            "password": account.password,
            "name" : account.name,
            "homePhone" : account.homePhone,
            "storeId" : account.storeId
        ]

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        UIView .animate(withDuration: 0.3) {
            self.blackCover.alpha = 0
            self.sexPickerView.alpha = 0
            self.datePicker.alpha = 0
        }
    }
    
    private func findClosestStore(location : CLLocation) -> NSDictionary {
        var coordinates = [NSDictionary]()
        for i in 0..<filteredAreas.count {
            let stores = filteredAreas[i].stores
            for j in 0..<stores.count {
                let coord = CLLocation(latitude: CLLocationDegrees(stores[j].latitude), longitude: CLLocationDegrees(stores[j].longitude))
                let indexAndCoord: NSDictionary = [
                    "section" : i,
                    "row" : j,
                    "coordinate" : coord
                ]
                coordinates.append(indexAndCoord)
            }
        }
        
        let closest = coordinates.min(by:
        { ($0["coordinate"] as! CLLocation).distance(from: location) < ($1["coordinate"] as! CLLocation).distance(from: location) })
        
        print(closest as Any)
        return closest!
    }

}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == storeTableView) {
            return filteredAreas.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == accountTableView) {
            return 3
        }
        else if (tableView == infoTableView) {
            return 2
        }
        else if (tableView == storeTableView) {
            let stores = filteredAreas[section].stores
            return stores.count
        }
        else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == accountTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
            switch indexPath.row {
                case 0:
                    cell.field = "建立帳號："
                    cell.placeholder = "請輸入手機號碼"
                    cell.fieldType = FieldType.Number
                case 1:
                    cell.field = "輸入密碼："
                    cell.placeholder = "請輸入您的新密碼"
                    cell.fieldType = FieldType.Password
                case 2:
                    cell.field = "再次輸入："
                    cell.placeholder = "請再輸入相同的密碼"
                    cell.fieldType = FieldType.Password
                default:
                    cell.field = ""
            }
            cell.layoutSubviews()
            cell.answerField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        }
        else if (tableView == infoTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
            cell.selectionStyle = .none
            switch indexPath.row {
                case 0:
                    cell.field = "姓名："
                    cell.placeholder = "請輸入完整姓名"
                    cell.fieldType = FieldType.Text
                case 1:
                    cell.field = "市話："
                    cell.placeholder = "請輸入市話"
                    cell.fieldType = FieldType.Number
                default:
                    cell.field = ""
            }
            cell.layoutSubviews()
            cell.answerField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        }
        else if (tableView == storeTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath) as! StoreCell
            cell.selectionStyle = .none
            cell.store = filteredAreas[indexPath.section].stores[indexPath.row].name
            cell.layoutSubviews()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "none", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = SNOW
        if tableView == storeTableView {
            headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36)
            let border = UIView(frame: CGRect(x: 0, y: 36, width: UIScreen.main.bounds.width, height: 1))
            border.backgroundColor = DEFAULT_SEPARATOR
            headerView.addSubview(border)
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 16, y: 8, width: UIScreen.main.bounds.width, height: 20)
            myLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
            myLabel.textColor = MYTLE
            let areaName : String
            areaName = filteredAreas[section].area

            myLabel.text = areaName

            headerView.addSubview(myLabel)

            return headerView

        }
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == storeTableView {
            if (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0) {
                return 0
            }
            return 36
        }
        else {
            return 0
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("hehe", scrollView.contentOffset.x)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        if tableView == infoTableView {
//            if (indexPath.row == 1) {
//                UIView .animate(withDuration: 0.3) {
//                    self.blackCover.alpha = 0.5
//                    self.datePicker.alpha = 1
//                    self.sexPickerView.alpha = 0
//                }
//                self.view.endEditing(true)
//            }
//            else if (indexPath.row == 5) {
//                UIView .animate(withDuration: 0.3) {
//                    self.blackCover.alpha = 0.5
//                    self.sexPickerView.alpha = 1
//                    self.datePicker.alpha = 0
//                }
//                self.view.endEditing(true)
//            }
//            else {
//                UIView .animate(withDuration: 0.3) {
//                    self.datePicker.alpha = 0
//                    self.sexPickerView.alpha = 0
//                }
//            }
        }
        if tableView == storeTableView {
            selectedStoreID = filteredAreas[indexPath.section].stores[indexPath.row].id
            account.storeId = selectedStoreID
            self.view.endEditing(true)
            textFieldDidChange()
        }
    }

    @objc func textFieldDidChange() {
        if (mainScrollView.contentOffset.x == 0) {
            let cell0 = accountTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
            let cell1 = accountTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
            let cell2 = accountTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
            
            if (cell0.answerField.text != "" &&
                cell1.answerField.text != "" &&
                cell2.answerField.text != "") {
                next0.alpha = 1.0
                next0.isEnabled = true
            }
            else {
                next0.alpha = 0.5
                next0.isEnabled = false
            }
        }
        else if (mainScrollView.contentOffset.x == UIScreen.main.bounds.width) {
            let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
            let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell

            if (cell0.answerField.text != "") {
                next1.alpha = 1.0
                next1.isEnabled = true
            }
            else {
                next1.alpha = 0.5
                next1.isEnabled = false
            }
        }
        else if (mainScrollView.contentOffset.x == UIScreen.main.bounds.width * 2) {
            if (selectedStoreID != -1) {
                next2.alpha = 1.0
                next2.isEnabled = true
            }
            else {
                next2.alpha = 0.5
                next2.isEnabled = false
            }
        }
        else if (mainScrollView.contentOffset.x == UIScreen.main.bounds.width * 3) {
            if (passcodeField.text?.count == 6) {
                next3.alpha = 1.0
                next3.isEnabled = true
            }
            else {
                next3.alpha = 0.5
                next3.isEnabled = false
            }

        }
    }

}

extension RegistrationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        let cell5 = infoTableView.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! FormCell
        if row == 0 {
            cell5.answer = "男性"
        }
        else {
            cell5.answer = "女性"
        }
        cell5.layoutSubviews()
        self.view.endEditing(true)
        textFieldDidChange()
    }

}

extension RegistrationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }


}

extension RegistrationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        if (searchText.isEmpty) {
            filteredAreas = allAreas
        }
        else {
            filteredAreas = [Area]()
            allAreas.forEach { (area) in
                var area = area
                let stores = area.stores
                var searchedStores = [Store]()

                stores.forEach { (store) in
                    if (store.name.contains(searchText)) {
                        searchedStores.append(store)
                    }
                }
                area.stores = searchedStores
                filteredAreas.append(area)
            }
        }
        storeTableView.reloadData()
    }
}

extension RegistrationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // Select one time only
        if (closestStore.count == 0) {
            let userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            closestStore = self.findClosestStore(location: userLocation)
            let indexPath = IndexPath(row: closestStore["row"] as! Int, section: closestStore["section"] as! Int)
            selectedStoreID = filteredAreas[indexPath.section].stores[indexPath.row].id
            account.storeId = selectedStoreID
            UIView.animate(withDuration: 0) {
                self.storeTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            } completion: { (Bool) in
                self.textFieldDidChange()
            }

        }
    }
}
