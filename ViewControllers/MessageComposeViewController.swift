//
//  MessageComposeViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/3.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation
import UIKit

class MessageComposeViewController: UIViewController, UITextViewDelegate {
    var messageType : MessageType?
    var role : Role?
    var consumer : Consumer?
    var threadId : Int?
    var thread = Thread.init(id: 0, type: 0, isRead: 0, sender: "", message: "", updatedDate: "", consumerId: 0)
    var attachedImages = [UIImage]()
    var spinner = UIActivityIndicatorView(style: .gray)
    
    @IBOutlet weak var composeViewBottomConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var scrollViewBottomConstraint: NSLayoutConstraint? // for keyboard hide and show
    var bottomConstraint: NSLayoutConstraint?
    var attachedImageViews = [UIImageView]()
    var imageTopConstraints = [NSLayoutConstraint]()
    var deleteButtons = [UIButton]()
    var selectedRow = 0
//    var kbSize = CGSize(width: 0.0, height: 0.0)
    var keyboardHeight = CGFloat(0)
    
    fileprivate var lineCollectionViewBottomConstraint1: NSLayoutConstraint?
    fileprivate var lineCollectionViewBottomConstraint2: NSLayoutConstraint?
    
    var cancel : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(MSG_TITLE_CANCEL, for: .normal)
        button.setTitleColor(ATLANTIS_GREEN, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Regular", size: 17)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    var header : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Medium", size: 31)
        textLabel.text = "新增訊息"
        textLabel.textColor = MYTLE
        return textLabel
    }()


    var send : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送出", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        button.isEnabled = true
        return button
    }()
    
    var typeLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "問題類型："
        textLabel.textColor = BLACKAlpha40
        textLabel.isHidden = true
        return textLabel
    }()
    
    var consumerLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "會員姓名："
        textLabel.textColor = BLACKAlpha40
        textLabel.isHidden = true
        return textLabel
    }()
    
    var prescriptionNameLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "處方人名："
        textLabel.textColor = BLACKAlpha40
        textLabel.isHidden = true
        return textLabel
    }()

    var typeSelection : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("請選擇", for: .normal)
        button.titleLabel?.sizeToFit()
        button.setTitleColor(MYTLE, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(typeSelectionButtonTapped), for: .touchUpInside)
        return button
    }()

    var contentScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = UIColor .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()

    var descView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textView.textColor = .black
        textView.textContainerInset = .zero; // fix the silly UITextView bug
        textView.textContainer.lineFragmentPadding = 0; // fix the silly UITextView bug
        textView.isScrollEnabled = false
        return textView
    }()
    
    var descPlaceholder : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "問題描述..."
        textLabel.textColor = BLACKAlpha40
        return textLabel
    }()
    
    var arwDown : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: " arw_down_sm_grey")
        return imageView
    }()

    var attach : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_camera_grey"), for: .normal)
        button.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var line : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_circle_smiley"), for: .normal)
        button.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var separator : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BLACKAlpha20
        return view
    }()
    
    var blackCover : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    lazy var pickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        picker.alpha = 0
        picker.delegate = self
        picker.setValue(MYTLE, forKeyPath: "textColor")
        return picker
    }()
    
    lazy var lineImageCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = SNOW
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LineImageCell.self, forCellWithReuseIdentifier: "lineImage")
        collectionView.backgroundColor = WHITE_SMOKE
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let threadId = threadId {
            thread.id = threadId
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = UIColor .white
        view .addSubview(cancel)
        view .addSubview(header)
        view .addSubview(send)
        view .addSubview(typeLabel)
        view .addSubview(consumerLabel)
        view .addSubview(typeSelection)
        typeSelection .addSubview(arwDown)
        view .addSubview(attach)
        view .addSubview(line)
        view .addSubview(separator)
        view .addSubview(contentScrollView)
        contentScrollView .addSubview(descView)
        contentScrollView .addSubview(descPlaceholder)
        view .addSubview(blackCover)
        view .addSubview(pickerView)
        view .addSubview(lineImageCollectionView)

        descView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blackCover.addGestureRecognizer(tap)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)

        self.setupLayout()
        
        hideKeyboardWhenTappedOnView()
        
    }
    
    @objc private func cancelButtonTapped(sender: UIButton!) {
        if (send.alpha != 1) {
            self.dismiss(animated: true) {
            }
        }
        else {
            GlobalVariables.showAlertWithOptions(title: MSG_TITLE_EXIT_EDITING, message: MSG_EXIT_EDITING, confirmString: MSG_TITLE_EXIT, vc: self) {
                self.dismiss(animated: true) {
                }
            }
        }
    }
    
    @objc private func attachButtonTapped(sender: UIButton!) {
        let alert = UIAlertController(title: "選擇圖檔", message: "", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "拍照", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
            self.view.endEditing(true)
        }))

        alert.addAction(UIAlertAction(title: "圖庫", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
            self.view.endEditing(true)
        }))
        
        alert.addAction(UIAlertAction(title: MSG_TITLE_CANCEL, style: .cancel , handler:{ (UIAlertAction)in
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }
    
    @objc private func lineButtonTapped(sender: UIButton!) {
        lineCollectionViewBottomConstraint1?.isActive = false
        lineCollectionViewBottomConstraint2?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.blackCover.alpha = 0.5
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }

    @objc private func sendButtonTapped(sender: UIButton!) {
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        
        ATTACHMENTS = []
        for imageView in attachedImageViews {
            attachedImages.append(imageView.image!)
        }
        sender.isEnabled = false
        let myGroup = DispatchGroup()
        
        if (attachedImages.count > 0) {
            for image in attachedImages {
                myGroup.enter()
                uploadImage(withImage: image, group: myGroup)
            }
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                self.sendMessage()
            }       
        }
        else {
            self.sendMessage()
        }
    }
    
    private func sendMessage() {
        if (messageType == MessageType.New ||
            messageType == MessageType.Prescription) {
            if (self.role == Role.Consumer) {
                NetworkManager.createThread(typeId: thread.type, message: thread.message, attachments:ATTACHMENTS) { (result) in
                    DispatchQueue.main.async {
                        if (result["status"] as! Int == 1) {
                            NotificationCenter.default.post(name: Notification.Name("CreatedThread"), object: nil)
                            self.send.isEnabled = true
                            self.dismiss(animated: true) {
                            }
                        }
                        else if (result["status"] as! Int == -1) {
                            GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                        }
                        else {
                            GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                        }
                        self.spinner.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
            else {
                NetworkManager.createStoreThread(typeId: 3, consumerId: self.consumer!.id, message: thread.message, attachments:ATTACHMENTS) { (result) in
                    DispatchQueue.main.async {
                        if (result["status"] as! Int == 1) {
                            NotificationCenter.default.post(name: Notification.Name("CreatedThread"), object: nil)
                            self.send.isEnabled = true
                            self.dismiss(animated: true) {
                            }
                        }
                        else if (result["status"] as! Int == -1) {
                            GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                        }
                        else {
                            GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                        }
                        self.spinner.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }

            }
        }
        else {
            if (self.role == Role.Consumer) {
                NetworkManager.addMessage(threadId: thread.id, message: thread.message, attachments: ATTACHMENTS) { (result) in
                    DispatchQueue.main.async {
                        if (result["status"] as! Int == 1) {
                            NotificationCenter.default.post(name: Notification.Name("AddedMessage"), object: nil)
                            self.send.isEnabled = true
                            self.dismiss(animated: true) {
                            }
                        }
                        else if (result["status"] as! Int == -1) {
                            GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                        }
                        else {
                            GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                        }
                        self.spinner.stopAnimating()
                        self.view.isUserInteractionEnabled = true

                    }
                }
            }
            else {
                if (self.messageType == MessageType.ReplyMessage) {
                    NetworkManager.addStoreMessage(threadId: thread.id, message: thread.message, attachments: ATTACHMENTS) { (result) in
                        DispatchQueue.main.async {
                            if (result["status"] as! Int == 1) {
                                NotificationCenter.default.post(name: Notification.Name("AddedMessage"), object: nil)
                                self.send.isEnabled = true
                                self.dismiss(animated: true) {
                                }
                            }
                            else if (result["status"] as! Int == -1) {
                                GlobalVariables.showAlert(title: self.title, message: ERR_CONNECTING, vc: self)
                            }
                            else {
                                GlobalVariables.showAlert(title: self.title, message: result["message"] as? String, vc: self)
                            }
                            self.spinner.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        }
                    }
                }
                else {
                    NetworkManager.addRequestMessage(threadId: thread.id, message: thread.message, attachments: ATTACHMENTS) { (result) in
                        print(result)
                        if (result["status"] as! Int == 1) {
                            NotificationCenter.default.post(name: Notification.Name("AddedRequestMessage"), object: nil)
                            DispatchQueue.main.async {
                                self.send.isEnabled = true
                                self.dismiss(animated: true) {
                                }
                                self.spinner.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                            }
                        }
                    }

                }
            }
        }
    }
    
    @objc private func typeSelectionButtonTapped(sender: UIButton!) {
        self.view.endEditing(true)
        if (role == Role.Consumer) {
            lineCollectionViewBottomConstraint2?.isActive = false
            lineCollectionViewBottomConstraint1?.isActive = true
            UIView .animate(withDuration: 0.3) {
                self.blackCover.alpha = 0.5
                self.pickerView.alpha = 1
                self.view.layoutIfNeeded()
                
            }
            UIView.animate(withDuration: 0.5) {
            }
            typeSelection.setTitle(MESSAGE_SUBJECTS[selectedRow], for: .normal)
            thread.type = selectedRow + 1
            
            if (thread.type == 1) {
                descPlaceholder.text = "請填寫實際領藥人姓名"
            }
            else {
                descPlaceholder.text = "問題描述..."
            }
        }
        else if (role == Role.MemberStore) {
            let consumerSearchVC = ConsumerSearchViewController()
            consumerSearchVC.purpose = ConsumerSearchPurpose.SendMessage
            self.present(consumerSearchVC, animated: true) {
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        lineCollectionViewBottomConstraint2?.isActive = false
        lineCollectionViewBottomConstraint1?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        UIView .animate(withDuration: 0.3) {
            self.blackCover.alpha = 0
            self.pickerView.alpha = 0
        }
    }

    
    private func setupLayout() {
        if let type = messageType {
            switch type {
            case MessageType.New:
                header.text = "新增訊息"
                if let role = role {
                    switch role {
                    case Role.Consumer:
                        typeSelectionButtonTapped(sender: typeSelection)
                        typeLabel.isHidden = false
                    case Role.MemberStore:
                        consumerLabel.isHidden = false
                    }
                }
                break
            case MessageType.Prescription:
                header.text = "新增訊息"
                if let role = role {
                    switch role {
                    case Role.Consumer:
                        typeSelection.setTitle(MESSAGE_SUBJECTS[0], for: .normal)
                        typeLabel.isHidden = false
                        thread.type = 1
                        descPlaceholder.text = "請填寫實際領藥人姓名"

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Change `0.05` to the desired number of seconds.
                            self.attachButtonTapped(sender: self.attach)
                        }
                    case Role.MemberStore:
                        consumerLabel.isHidden = false
                    }
                }
                break
            case MessageType.ReplyMessage:
                header.text = "回覆訊息"
                typeLabel.isHidden = true
                typeSelection.isHidden = true
                break
            case MessageType.ReplyRequest:
                header.text = "回覆訊息"
                typeLabel.isHidden = true
                typeSelection.isHidden = true
                break
            }

        }
        typeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        typeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 139).isActive = true
        typeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        consumerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        consumerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 139).isActive = true
        consumerLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        consumerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        typeSelection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 97).isActive = true
        typeSelection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 139).isActive = true
        typeSelection.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        arwDown.leftAnchor.constraint(equalTo: typeSelection.rightAnchor).isActive = true
        arwDown.centerYAnchor.constraint(equalTo: typeSelection.centerYAnchor).isActive = true
        arwDown.widthAnchor.constraint(equalToConstant: 32).isActive = true
        arwDown.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        separator.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        separator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 175).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        contentScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        scrollViewBottomConstraint?.isActive = true
        
        descView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        descView.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        descView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        bottomConstraint = descView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -34)
        bottomConstraint?.isActive = true

        descPlaceholder.leftAnchor.constraint(equalTo: contentScrollView.leftAnchor, constant: 16).isActive = true
        descPlaceholder.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        descPlaceholder.widthAnchor.constraint(equalToConstant: 200).isActive = true
        descPlaceholder.heightAnchor.constraint(equalToConstant: 20).isActive = true

        cancel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        header.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        header.widthAnchor.constraint(equalToConstant: 233).isActive = true
        header.heightAnchor.constraint(equalToConstant: 41).isActive = true

        send.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
        send.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        send.widthAnchor.constraint(equalToConstant: 88).isActive = true
        send.heightAnchor.constraint(equalToConstant: 56).isActive = true

        attach.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor).isActive = true
        attach.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true

        line.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: attach.leftAnchor, constant: -10).isActive = true

        blackCover.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blackCover.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        blackCover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        blackCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        lineImageCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        lineImageCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lineImageCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        lineCollectionViewBottomConstraint1 = lineImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.width)
        lineCollectionViewBottomConstraint2 = lineImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        lineCollectionViewBottomConstraint1?.isActive = true
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func updateCosumer() {
        if let consumer = consumer {
            typeSelection.setTitle(consumer.name, for: .normal)
            enableSendButton()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }

    
    func textViewDidChange(_ textView: UITextView) {
        descPlaceholder.isHidden = !textView.text.isEmpty
        enableSendButton()
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { // Change `0.05` to the desired number of seconds.
            self.scrollToCursor()
        }
        thread.message = textView.text
    }
    
    private func scrollToCursor() {
        // TextView
        let textViewOrigin = self.view.convert(descView.frame, from: self.view).origin
        
        // Cursor
        let textViewCursor = descView.caretRect(for: descView.selectedTextRange!.start).origin
        let cursorPoint = CGPoint(x: textViewCursor.x + textViewOrigin.x, y: textViewCursor.y + contentScrollView.frame.origin.y - contentScrollView.contentOffset.y + 25)
        
        let keyboardTop = self.view.frame.size.height - keyboardHeight
        print("keyboardTop ", keyboardTop)
        
        print("cursor position y ", cursorPoint.y)
        
        if (self.view.frame.origin.y + cursorPoint.y > keyboardTop &&
            cursorPoint.y != .infinity) {
            contentScrollView.contentOffset = CGPoint(x: 0, y: (cursorPoint.y - (self.view.frame.size.height - keyboardHeight)) + contentScrollView.contentOffset.y)
        }

    }

    @objc func keyboardWillShow(notification:NSNotification){

//        print("keyboardWillShow")
//
//        let userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        kbSize = keyboardFrame.size
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            self.scrollViewBottomConstraint?.isActive = false
            self.scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight)
            self.scrollViewBottomConstraint?.isActive = true
        }

        
    }

    @objc func keyboardWillHide(notification:NSNotification){
        print("keyboardWillHide")

        self.scrollViewBottomConstraint?.isActive = false
        self.scrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.scrollViewBottomConstraint?.isActive = true

    }
    
    @objc func addImageToView(image:UIImage){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        delete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        contentScrollView .addSubview(imageView)
        imageView.addSubview(delete)
        
//        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        var topConstraint: NSLayoutConstraint?
        
        if (attachedImageViews.count == 0) {
            topConstraint = imageView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30)
        }
        else {
            topConstraint = imageView.topAnchor.constraint(equalTo: attachedImageViews[attachedImageViews.count - 1].bottomAnchor, constant: 30)
        }
        topConstraint?.isActive = true
        
        delete.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        delete.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant: 30).isActive = true
        delete.heightAnchor.constraint(equalToConstant: 30).isActive = true

        bottomConstraint?.isActive = false
        bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -34)
        bottomConstraint?.isActive = true
        
        deleteButtons.append(delete)
        attachedImageViews.append(imageView)
        imageTopConstraints.append(topConstraint!)

        enableSendButton()
    }
    
    @objc private func deleteButtonTapped(sender: UIButton!) {
        let deletedIndex = deleteButtons.firstIndex(of: sender)
        let imageView = attachedImageViews[deletedIndex!]
        imageView.removeFromSuperview()
        if (deletedIndex == deleteButtons.count - 1) {
        }
        else if (deletedIndex == 0) {
            let imageView = attachedImageViews[1]
            var topConstraint = imageTopConstraints[1]
            topConstraint.isActive = false
            topConstraint = imageView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 30)
            topConstraint.isActive = true
        }
        else {
            let previousImageView = attachedImageViews[deletedIndex! - 1]
            let nextImageView = attachedImageViews[deletedIndex! + 1]
            var topConstraint = imageTopConstraints[deletedIndex! + 1]
            topConstraint.isActive = false
            topConstraint = nextImageView.topAnchor.constraint(equalTo: previousImageView.bottomAnchor, constant: 30)
            topConstraint.isActive = true
        }
        deleteButtons.remove(at: deletedIndex!)
        attachedImageViews.remove(at: deletedIndex!)
        imageTopConstraints.remove(at: deletedIndex!)
        
        enableSendButton()
    }

    func enableSendButton() {
        if role == Role.Consumer {
            if (descView.text.isEmpty && attachedImageViews.count == 0) {
                send.alpha = 0.5
                send.isEnabled = false
            }
            else {
                send.alpha = 1.0
                send.isEnabled = true
            }
        }
        else if role == Role.MemberStore {
            if (descView.text.isEmpty && attachedImageViews.count == 0) {
                send.alpha = 0.5
                send.isEnabled = false
            }
            else {
                if (messageType == MessageType.ReplyMessage ||
                    messageType ==  MessageType.ReplyRequest ||
                        (consumer) != nil) {
                    send.alpha = 1.0
                    send.isEnabled = true
                }
                else {
                    send.alpha = 0.5
                    send.isEnabled = false
                }
            }
        }
    }
}

extension MessageComposeViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return MESSAGE_SUBJECTS.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return MESSAGE_SUBJECTS[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeSelection.setTitle(MESSAGE_SUBJECTS[row], for: .normal)
        selectedRow = row
        thread.type = selectedRow + 1
        if (thread.type == 1) {
            descPlaceholder.text = "請填寫實際領藥人姓名"
        }
        else {
            descPlaceholder.text = "問題描述..."
        }
    }

}

extension MessageComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToView(image: pickedImage)
        }

        
        picker.dismiss(animated: true) {
        }

        
    }
}

extension MessageComposeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24;
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineImage", for: indexPath) as! LineImageCell
        cell.mainImage = UIImage(named:"gps_line_\(indexPath.row + 1)")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        lineCollectionViewBottomConstraint2?.isActive = false
        lineCollectionViewBottomConstraint1?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.blackCover.alpha = 0
        }
        addImageToView(image: UIImage(named:"gps_line_\(indexPath.row + 1)")!)
    }
}


//extension UIScrollView {
//    func updateContentView() {
//        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
//    }
//}
