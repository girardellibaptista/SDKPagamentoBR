//
//  CameraViewController.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit

class CameraViewController: UIViewController, CameraViewProtocol {

    // MARK: - VARIABLES
	var presenter: CameraPresenterProtocol?

    // MARK: - LIFE CYCLE
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.willCheckSettings()
        if let layer = presenter?.willGetCameraLayer(on: self.view.bounds) {
            self.view.layer.addSublayer(layer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.willAddCameraObservers()
        presenter?.willStartCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.willRemoveCameraObservers()
        presenter?.willStopCamera()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        presenter?.updateCameraLayer(for: self.view.layer.bounds)
    }

}
