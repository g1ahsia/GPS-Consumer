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
    var spinner = UIActivityIndicatorView(style: .gray)

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
    
    var photo : UIButton = {
        var button =  UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("附上處方箋照片", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansTC-Bold", size: 17)
        button.backgroundColor = ATLANTIS_GREEN
        button.layer.cornerRadius = 10;
        button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        return button
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
        button.isEnabled = false
        return button
    }()
    
    var prescriptionImageView : UIImageView = {
       var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true;
        imageView.image = #imageLiteral(resourceName: "img_holder")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
                break
            case 1:
                cell.field = "身分證字號："
                cell.placeholder = "請輸入生分證字號"
                cell.fieldType = FieldType.Text
                break
            case 2:
                cell.field = "領藥人姓名："
                cell.placeholder = "請輸入完整姓名"
                cell.fieldType = FieldType.Text
                break
            case 3:
                cell.field = "領藥人電話："
                cell.placeholder = "請輸入電話"
                cell.fieldType = FieldType.Number
                break
            default:
                cell.field = ""
                break
        }
        return cell
    }
    
    private func setupLayout() {
        infoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        infoTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        prescriptionImageView.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 20).isActive = true
        prescriptionImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        prescriptionImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        prescriptionImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        photo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        photo.topAnchor.constraint(equalTo: prescriptionImageView.bottomAnchor, constant: 20).isActive = true
        photo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        photo.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        send.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        send.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 40).isActive = true
        send.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        send.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SNOW
        title = "處方箋領藥預約"
        self.view.addSubview(infoTableView)
        self.view.addSubview(prescriptionImageView)
        self.view.addSubview(photo)
        self.view.addSubview(send)
        setupLayout()
    }
    
    @objc private func photoButtonTapped(sender: UIButton!) {
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
        prescriptionImageView.image = image
        enableSendButton()
    }
    
    func enableSendButton() {
        send.alpha = 1.0
        send.isEnabled = true
    }
    
    @objc private func sendButtonTapped(sender: UIButton!) {
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        sender.isEnabled = false
        sender.alpha = 0.5
        self.sendMessage()
    }
    
    private func sendMessage() {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToView(image: pickedImage)
        }

        
        picker.dismiss(animated: true) {
        }

        
    }

}
