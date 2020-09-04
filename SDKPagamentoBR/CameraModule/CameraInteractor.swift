//
//  CameraInteractor.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit
import AVFoundation

class CameraInteractor: NSObject, CameraInteractorProtocol {

    enum Position {
        case front
        case back

        var devicePosition: AVCaptureDevice.Position {
            return self == .front ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
        }
    }

    // MARK: - VARIABLES
    weak var presenter: CameraPresenterProtocol?
    var metadataTypes: [AVMetadataObject.ObjectType]!
    var position: CameraInteractor.Position!
    lazy var sessionQueue = DispatchQueue.global(qos: .userInteractive)
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation

    // MARK: - INTERACTOR PROTOCOL
    func getCameraLayer(on frame: CGRect) -> CALayer? {
        createCameraSession(for: position.devicePosition)
        return createCameraLayer(for: frame)
    }

    @objc func startCamera() {
        checkCameraStatus()
    }

    @objc func stopCamera() {
        if let captureSession = captureSession, captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async {
                captureSession.stopRunning()
            }
        }
    }

    func checkCameraStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.checkCameraStatus()
                } else {
                   self?.presenter?.handleUngrantedAuthorization()
                }
            }
        case .authorized:
            if let captureSession = captureSession, !captureSession.isRunning {
                DispatchQueue.global(qos: .userInteractive).async {
                    captureSession.startRunning()
                }
            }
        @unknown default:
            fatalError("Case has not been handled yet")
        }
    }

    func didAdjustLayerToFrame(_ frame: CGRect) {
        self.videoPreviewLayer?.frame = frame
    }

    func willAddCameraObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(startCamera),
                                               name: Notification.Name.startCamera, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopCamera),
                                               name: Notification.Name.stopCamera, object: nil)
    }

    func willRemoveCameraObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.startCamera, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.stopCamera, object: nil)
    }

    // MARK: - METHODS
    private func createCameraSession(for position: AVCaptureDevice.Position) {
        guard let captureDevice = cameraWithPosition(position: position) else {return}
        self.captureDevice = captureDevice
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession = AVCaptureSession()
        if captureDevice.supportsSessionPreset(AVCaptureSession.Preset.hd1920x1080) {
            captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        }
        if let inputs = captureSession?.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession?.removeInput(input)
            }
        }
        captureSession?.addInput(input)
    }

    private func createCameraLayer(for frame: CGRect) -> CALayer? {
        guard let captureSession = captureSession else {return nil}
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = frame

        if orientation == UIInterfaceOrientation.landscapeLeft {
            videoPreviewLayer?.connection?.videoOrientation = .landscapeLeft
        } else if orientation == UIInterfaceOrientation.landscapeRight {
            videoPreviewLayer?.connection?.videoOrientation = .landscapeRight
        } else {
            videoPreviewLayer?.connection?.videoOrientation = .portrait
        }

        addMetaDataRecognition()
        return videoPreviewLayer
    }

    private func addMetaDataRecognition() {
        if metadataTypes.count > 0 {
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            captureMetadataOutput.metadataObjectTypes = metadataTypes
        }
    }

    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position) {
            try? device.lockForConfiguration()
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
                if device.isSmoothAutoFocusSupported {
                    device.isSmoothAutoFocusEnabled = true
                }
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                device.whiteBalanceMode = .autoWhiteBalance
            }
            if device.isLowLightBoostSupported {
                device.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
            device.unlockForConfiguration()
            return device
        }
        return nil
    }
}
// MARK: - METADATA OUTPUT DELEGATE
extension CameraInteractor: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        let filteredMetadataObjects = metadataObjects.filter {metadataTypes.contains($0.type)}
        if let metaDataObject = filteredMetadataObjects.first {
            presenter?.handleMetaDataObject(metaDataObject)
        }
    }
}
