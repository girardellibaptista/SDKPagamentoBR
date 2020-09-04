//
//  CameraProtocols.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import AVFoundation
import UIKit

// MARK: - Enums
enum CameraMetadataOption {
    case qr
    case barCode
}

// MARK: Wireframe -
protocol CameraWireframeProtocol: class {

}
// MARK: Presenter -
protocol CameraPresenterProtocol: class {

    //View to presenter
    func updateCameraLayer(for frame: CGRect)
    func willGetCameraLayer(on frame: CGRect) -> CALayer?
    func willStartCamera()
    func willStopCamera()
    func willCheckSettings()
    func willAddCameraObservers()
    func willRemoveCameraObservers()

    //Interactor to presenter
    func handleUngrantedAuthorization()
    func handleMetaDataObject(_ metadataObject: AVMetadataObject)
}

// MARK: Interactor -
protocol CameraInteractorProtocol: class {

    var presenter: CameraPresenterProtocol? { get set }

    func getCameraLayer(on frame: CGRect) -> CALayer?
    func didAdjustLayerToFrame(_ frame: CGRect)
    func startCamera()
    func stopCamera()
    func checkCameraStatus()
    func willAddCameraObservers()
    func willRemoveCameraObservers()
}

// MARK: View -
protocol CameraViewProtocol: class {
    var presenter: CameraPresenterProtocol? { get set }
}

protocol CameraDelegate: class {
    func didHandleUngrantedAuthorization()
    func didHandleMetadataObject(_ metadataObject: AVMetadataObject)
}
extension CameraDelegate {
    func didHandleUngrantedAuthorization() {}
    func didHandleMetadataObject(_ metadataObject: AVMetadataObject) {}
}
