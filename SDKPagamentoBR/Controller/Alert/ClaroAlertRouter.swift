//
//  ClaroAlertRouter.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit

public class ClaroAlertRouter: ClaroAlertWireframeProtocol {

    // MARK: - VARIABLES
    weak var viewController: UIViewController?

    // MARK: -
    public static func createModule(alertInfo: AlertInfo, onWindow: Bool? = nil) -> AlertViewController {

        let view = AlertViewController(nibName: "AlertViewController", bundle: Bundle(for: AlertViewController.self))
        let interactor = ClaroAlertInteractor()
        let router = ClaroAlertRouter()
        let presenter = ClaroAlertPresenter(interface: view,
                                            interactor: interactor,
                                            router: router,
                                            onWindow: onWindow)
        presenter.alertInfo = alertInfo

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    // MARK: - ROUTER PROTOCOL
    func willAddAlert(onWindow: Bool?) {
        UIApplication.window.endEditing(true)
        if let viewController = viewController,
            var topController = UIApplication.window.rootViewController {
            
            if let onWindow = onWindow, onWindow {
                let tabBar = UIApplication.tabBarController
                tabBar?.addChild(viewController)
                viewController.didMove(toParent: tabBar)
                UIApplication.window.addFillingSubview(viewController.view)
                return
            }
            
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            if topController != UIApplication.window.rootViewController {
                topController.addChild(viewController, with: UIApplication.window.bounds)
            } else {
                (topController as? UINavigationController)?.topViewController?
                    .addChild(viewController, with: UIApplication.window.bounds)
            }
        }
    }

    func willRemoveAlert() {
        viewController?.removeControllerFromParent()
    }
}
