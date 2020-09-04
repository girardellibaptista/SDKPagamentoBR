//
//  CameraPresenter.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit
import AVFoundation

class CameraPresenter: CameraPresenterProtocol {

    // MARK: - VARIABLES
    weak private var view: CameraViewProtocol?
    weak var delegate: CameraDelegate?
    var interactor: CameraInteractorProtocol?
    private let router: CameraWireframeProtocol

    // MARK: - INITIALIZERS
    init(interface: CameraViewProtocol, interactor: CameraInteractorProtocol?, router: CameraWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    // MARK: - FROM VIEW PROTOCOL
    func willStartCamera() {
        interactor?.startCamera()
    }

    func willStopCamera() {
        interactor?.stopCamera()
    }

    func willGetCameraLayer(on frame: CGRect) -> CALayer? {
        return interactor?.getCameraLayer(on: frame)
    }

    func updateCameraLayer(for frame: CGRect) {
        interactor?.didAdjustLayerToFrame(frame)
    }

    func willCheckSettings() {
        interactor?.checkCameraStatus()
    }

    func willAddCameraObservers() {
        interactor?.willAddCameraObservers()
    }

    func willRemoveCameraObservers() {
        interactor?.willRemoveCameraObservers()
    }

    // MARK: - FROM INTERACTOR PROTOCOL
    func handleUngrantedAuthorization() {
        delegate?.didHandleUngrantedAuthorization()
    }

    func handleMetaDataObject(_ metadataObject: AVMetadataObject) {
        delegate?.didHandleMetadataObject(metadataObject)
    }
}
