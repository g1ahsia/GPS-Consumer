//
//  QRCodeScannerViewController.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/22.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import AVFoundation
import UIKit

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var captureBracket : UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "capture")
        return imageView
    }()
    
    var cancel : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = MYTLE
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height - UIScreen.main.bounds.width)/2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        //        previewLayer.frame = view.layer.bounds
        captureBracket.frame = CGRect(x: (previewLayer.frame.width - 191)/2, y: (previewLayer.frame.width - 183)/2, width: 191, height: 183)
        previewLayer.videoGravity = .resizeAspectFill
        
//        let cancel = UIButton()
//        cancel.setImage(#imageLiteral(resourceName: " ic_fill_cross_grey"), for: .normal)
//        cancel.frame = CGRect(x: 16, y: 16, width: 30, height: 30)
//        cancel.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        view.layer.addSublayer(previewLayer)
        previewLayer.addSublayer(captureBracket.layer)
        
        view.addSubview(cancel)
        cancel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        cancel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true

        captureSession.startRunning()
        
        let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: captureBracket.frame)
        metadataOutput.rectOfInterest = rectOfInterest

    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            
            let vc = self.presentingViewController
            dismiss(animated: true) {
                GlobalVariables.showAlert(title: MSG_TITLE_GAIN_POINT, message: MSG_GAIN_POINT, vc: vc)
            }
        }

    }

    func found(code: String) {
        print(code)

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc private func cancelButtonTapped(sender: UIButton!) {
        self.dismiss(animated: true) {
        }
    }
}
