//
//  QRScannerView.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
    func showSimpleAlert(alert: UIAlertController)
    func show()
}

class QRScannerView: UIView {
    
    
    
    weak var delegate: QRScannerViewDelegate?
    
    var captureSession: AVCaptureSession?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInitialSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitialSetup()
    }
    
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}
extension QRScannerView {
    
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
    
    func checkCameraStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.checkCameraStatus()
                } else {
                   self?.handleUngrantedAuthorization()
                }
            }
        case .authorized:
            self.startScanning()
        @unknown default:
            fatalError("Case has not been handled yet")
        }
    }
    
    func handleUngrantedAuthorization() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            let alert = UIAlertController(title: nil, message: "Claro Pay deseja ter acesso à câmera. Ative a permissão nos ajustes.",
                                          preferredStyle: .alert)
            let laterAction = UIAlertAction(title: "Mais tarde",
                                            style: .default, handler: nil)
            let settingsAction = UIAlertAction(title: "Ir para ajustes.",
                                               style: .default) { action in
                                                UIApplication.openSettings()
            }
            alert.addAction(laterAction)
            alert.addAction(settingsAction)
            self.delegate?.showSimpleAlert(alert: alert)
        }
    }
    
    private func doInitialSetup() {
        clipsToBounds = true
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
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.qrScanningSucceededWithCode(code)
    }
    
    func showAlertModal(){
        delegate?.show()
        
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        //stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            DispatchQueue.main.async(execute: { [weak self] in
                do {
                    //try  self?.processQRCode(json: stringValue)
                    //self?.found(code: stringValue)
                    self?.stopScanning()
                     self?.showAlertModal()
                    
                } catch {
                    //self?.showErrorToast()
                }
            })
        }
    }
    
}
