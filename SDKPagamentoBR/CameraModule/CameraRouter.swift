//
//  CameraRouter.swift
//  ClaroPay
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit
import AVFoundation

class CameraRouter: CameraWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule(with delegate: CameraDelegate, for position: CameraInteractor.Position, metadataOutputTypes: [AVMetadataObject.ObjectType]) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = CameraViewController(nibName: nil, bundle: nil)
        let interactor = CameraInteractor()
        let router = CameraRouter()
        let presenter = CameraPresenter(interface: view, interactor: interactor, router: router)
        presenter.delegate = delegate

        view.presenter = presenter
        interactor.presenter = presenter
        interactor.position = position
        interactor.metadataTypes = metadataOutputTypes
        router.viewController = view

        return view
    }
}
