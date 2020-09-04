//
//  ScanQRModuleController.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import AVFoundation
import ClaroPayStyle

public enum ScanningMode: Int {
    case clabe = 18
    case otp = 12
}

protocol ScanQRModuleViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}

public class ScanQRModuleController: KeyboardObserverViewController, CameraDelegate {
    
    weak var delegate: ScanQRModuleViewDelegate?
    var captureSession: AVCaptureSession?

    @IBOutlet weak var marginTop: UIImageView!
    @IBOutlet weak var marginBottom: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var btnInfo: ClaroButton!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var txtFldNumber: UITextField!
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var lblInstructionsManual: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet var cnstrntBottom: NSLayoutConstraint!
    
    var cnstrntTop: NSLayoutConstraint!
    var didScanCode = false

    public var scanningMode: ScanningMode = .clabe

    override public func viewDidLoad() {
        super.viewDidLoad()
        let cameraController = CameraRouter.createModule(with: self, for: .back, metadataOutputTypes: [.qr,.code128,.code39,.code93])
        self.addChild(cameraController)
        cameraController.didMove(toParent: self)
        cameraController.view.frame = cameraView.bounds
        self.lblScan.text = "send_money_qr_scan".localizableString()
        self.lblScan.font = ClaroPayFont.bold.font(size: .tinySma11)
        self.lblInstructions.text = "send_money_qr_inst".localizableString()
        self.lblInstructions.font = ClaroPayFont.regular.font(size: .smaller)
        self.marginTop.image = UIImage(named: "marginTop")
        self.marginBottom.image = UIImage(named: "marginBottom")
        self.vwCard.layer.addShadow()
        self.vwCard.layer.roundCorners(radius: 5)
        self.cnstrntTop = vwBottom.topAnchor.constraint(equalTo: vwTop.bottomAnchor)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func editingDidChange(textField: UITextField) {
        textField.text = textField.text?.components(
            separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let maxDigits = scanningMode.rawValue
        if textField.text?.count ?? 0 > maxDigits {
            textField.deleteBackward()
        }
    }
    
    override public func shouldUpdateView() {
        NotificationCenter.default.post(name: Notification.Name.stopCamera, object: nil)
        vwTop.alpha = 1.0
        cnstrntBottom.isActive = false
        cnstrntTop.isActive = true
        UIView.animate(withDuration: keyboardInfo?.animationDuration ?? 0.1) {self.view.layoutIfNeeded()}
    }
    
    override public func rebootView() {}
    
    @IBAction func restoreView() {
        didScanCode = false
        NotificationCenter.default.post(name: Notification.Name.startCamera, object: nil)
        vwTop.alpha = 0.0
        cnstrntTop.isActive = false
        cnstrntBottom.isActive = true
        UIView.animate(withDuration: keyboardInfo?.animationDuration ?? 0.1) {self.view.layoutIfNeeded()}
    }
}

extension ScanQRModuleController {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
       captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    /// Does the initial setup for captureSession
    private func doInitialSetup() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        
        captureSession?.startRunning()
    }
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.qrScanningSucceededWithCode(code)
    }
    
}

extension ScanQRModuleController: AVCaptureMetadataOutputObjectsDelegate {
    
    fileprivate func showToast(text: String) {
        showToastWithText(text)
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.showToast(text: stringValue)
        }
    }
}
