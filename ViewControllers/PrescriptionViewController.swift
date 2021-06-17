//
//  PrescriptionViewController.swift
//  GPS Consumer
//
//  Created by Allen Hsiao on 2021/6/10.
//

import Foundation
import UIKit

class PrescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var scrollViewBottomConstraint: NSLayoutConstraint? // for keyboard hide and show
    var spinner = UIActivityIndicatorView(style: .gray)
    var attachedImageViews = [UIImageView]()
    var photoTopConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var deleteButtons = [UIButton]()
    var imageTopConstraints = [NSLayoutConstraint]()
    var attachedImages = [UIImage]()
    var consumer : Consumer?

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
        textLabel.text = "處方箋領藥預約"
        textLabel.textColor = MYTLE
        return textLabel
    }()
    
    var pickupLabel : UILabel = {
        var textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont(name: "NotoSansTC-Regular", size: 15)
        textLabel.text = "本人領取："
        textLabel.textColor = BLACKAlpha40
        textLabel.isHidden = false
        return textLabel
    }()
    
    var pickerSwitch : UISwitch = {
        var theSwitch = UISwitch()
        theSwitch.translatesAutoresizingMaskIntoConstraints = false
        theSwitch.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        theSwitch.setOn(false, animated: false)
        return theSwitch
    }()
    
    var attach : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("附上處方箋照片", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
        return button
    }()

    var separator : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BLACKAlpha20
        return view
    }()

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

    var contentScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = UIColor .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! FormCell
        cell.selectionStyle = .none
        switch indexPath.row {
            case 0:
                cell.field = "病患姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.Text
                cell.answer = consumer?.name
                cell.answerField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                break
            case 1:
                cell.field = "身分證字號："
                cell.placeholder = "請輸入生分證字號"
                cell.fieldType = FieldType.Text
                cell.answer = consumer?.serialNumber
                cell.answerField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                break
            case 2:
                cell.field = "領藥人姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.Text
                cell.answerField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                break
            case 3:
                cell.field = "領藥人電話："
                cell.placeholder = "請輸入電話"
                cell.fieldType = FieldType.Number
                cell.answerField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                break
            default:
                cell.field = ""
                break
        }
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("didchange")
        enableSendButton()
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
        
//        attach.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 139).isActive = true
//        attach.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        
        pickupLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        pickupLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 139).isActive = true
        pickupLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pickupLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pickerSwitch.leftAnchor.constraint(equalTo: pickupLabel.rightAnchor).isActive = true
        pickerSwitch.centerYAnchor.constraint(equalTo: pickupLabel.centerYAnchor).isActive = true

        attach.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        attach.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 30).isActive = true
        attach.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        attach.heightAnchor.constraint(equalToConstant: 44).isActive = true

        contentScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: attach.bottomAnchor, constant: 10).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        separator.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        separator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 175).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        infoTableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        infoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "處方箋領藥預約"
        view .addSubview(cancel)
        view .addSubview(header)
        view .addSubview(send)
        view .addSubview(pickupLabel)
        view .addSubview(pickerSwitch)
        view .addSubview(separator)
        view .addSubview(infoTableView)
        view.addSubview(attach)
        view .addSubview(contentScrollView)
        setupLayout()
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch!)
    {
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        let cell3 = infoTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! FormCell

        if (sender.isOn == true){
            print("UISwitch state is now ON")
            cell2.answer = cell0.answer
            cell3.answer = consumer?.mobilePhone
            cell2.setNeedsLayout()
            cell3.setNeedsLayout()
        }
        else{
            print("UISwitch state is now Off")
            cell2.answer = ""
            cell3.answer = ""
        }
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
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        var topConstraint: NSLayoutConstraint?
        
        if (attachedImageViews.count == 0) {
            topConstraint = imageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 30)
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
            topConstraint = imageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 30)
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
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        let cell3 = infoTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! FormCell
        if (!(cell0.answer ?? "").isEmpty &&
            !(cell1.answer ?? "").isEmpty &&
            !(cell2.answer ?? "").isEmpty &&
            !(cell3.answer ?? "").isEmpty &&
            attachedImageViews.count > 0) {
            send.alpha = 1.0
            send.isEnabled = true
        }
        else {
            send.alpha = 0.5
            send.isEnabled = false
        }
    }
    
    @objc private func sendButtonTapped(sender: UIButton!) {
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        sender.isEnabled = false
        sender.alpha = 0.5
        
        ATTACHMENTS = []
        for imageView in attachedImageViews {
            attachedImages.append(imageView.image!)
        }
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
        let cell0 = infoTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! FormCell
        let cell1 = infoTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! FormCell
        let cell2 = infoTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! FormCell
        let cell3 = infoTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! FormCell

        NetworkManager.createPrescription(patientName: cell0.answer!, patientSerial: cell1.answer!, recipientName: cell2.answer!, recipientPhone: cell3.answer!, attachments:ATTACHMENTS) { (result) in
            DispatchQueue.main.async {
                if (result["status"] as! Int == 1) {
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
                self.send.isEnabled = true
                self.send.alpha = 1.0
                self.spinner.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToView(image: pickedImage)
        }
        picker.dismiss(animated: true) {
        }
    }
}
