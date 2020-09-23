//
//  UIViewController+Extension.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation
import UIKit

public enum NavigationBarConfig {
    case both
    case leftArrow
    case closeButton
    case none
    
}

public extension UIViewController {
    typealias tappAccept = () -> Void
    typealias tappCancel = () -> Void
    private static var topLogoImage = UIImageView()
    private static var backButton = UIButton(type: .system)
    private static var closeButton = UIButton(type: .system)
    var topLogoCLaroPay:UIImageView {
        get {
            return UIViewController.topLogoImage
        }
    }
    var BackButtonClaroPay:UIButton {
        get {
            return UIViewController.backButton
        }
    }
    
    var CloseButtonClaroPay:UIButton {
        get {
            return UIViewController.closeButton
        }
    }
    
    private func setHiddenElement(leftArrow: Bool, closeButton: Bool, completion: ((UIButton?, UIButton?) -> Void)?){
        
        topLogoCLaroPay.image = UIImage(named: "ClaroPayLogoOnboarding")
        topLogoCLaroPay.translatesAutoresizingMaskIntoConstraints = false
        topLogoCLaroPay.contentMode = .scaleAspectFit
        self.view.addSubview(topLogoCLaroPay)
        topLogoCLaroPay.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topLogoCLaroPay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        BackButtonClaroPay.setImage(UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        BackButtonClaroPay.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(BackButtonClaroPay)
        BackButtonClaroPay.translatesAutoresizingMaskIntoConstraints = false
        BackButtonClaroPay.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        BackButtonClaroPay.heightAnchor.constraint(equalToConstant: 20).isActive = true
        BackButtonClaroPay.widthAnchor.constraint(equalToConstant: 20).isActive = true
        BackButtonClaroPay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        
        CloseButtonClaroPay.setImage(UIImage(named: "cerrarApp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        CloseButtonClaroPay.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.view.addSubview(CloseButtonClaroPay)
        CloseButtonClaroPay.translatesAutoresizingMaskIntoConstraints = false
        CloseButtonClaroPay.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        CloseButtonClaroPay.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        if !leftArrow || !closeButton {
            BackButtonClaroPay.isHidden = closeButton == true ? true : false
            CloseButtonClaroPay.isHidden = leftArrow  == true ? true : false
        }else{
            BackButtonClaroPay.isHidden = false
            CloseButtonClaroPay.isHidden = false
        }
        completion?(BackButtonClaroPay,CloseButtonClaroPay)
    
        
    }
    
    func addActionBackButton(completion: ((UIButton?) -> Void)?){
        BackButtonClaroPay.removeTarget(nil, action: nil, for: .allEvents)
        completion?(BackButtonClaroPay)

    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func closeAction(){
        self.navigationController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("removeSplash"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("UpdateAlias"), object: nil, userInfo: nil)
    }

    func navigationBarHidden(){
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func showModalAlert(_ title: String? = nil,
                   message: String?,
                   attributedMessage: NSMutableAttributedString? = nil,
                   alertType: AlertType = AlertType.info,
                   btnTitleOk: String? = "Ok",
                   btnTitleDetail: String? = "Sair",
                   onWindow: Bool? = nil,
                   tapAlert: tappAccept? = nil, tapDetail: tappAccept? = nil) {
        DispatchQueue.main.async {
            
            var alertInfo = AlertInfo(title: title ?? alertType.defaultTitle, message: message,
                                      btnTitleOk: btnTitleOk, btnTitleDetail: nil,
                                      btnOkCompletion: tapAlert, btnDetailCompletion: tapDetail, type: alertType)
            alertInfo.attributtedMessage = attributedMessage
            let claroAlert = ClaroAlertRouter.createModule(alertInfo: alertInfo,
                                                           onWindow: onWindow)
            claroAlert.show()
        }
    }
    
    func showModalAlertCustom(_ title: String? = nil,
                         message: String?, alertType: AlertType = AlertType.info, tapAlert: tappAccept? = nil, tapDetail: tappAccept? = nil, _ titleBtnOk: String? = nil) {
        DispatchQueue.main.async {
            let alertInfo = AlertInfo(title: title ?? alertType.defaultTitle, message: message,
                                      btnTitleOk: titleBtnOk, btnTitleDetail: nil,
                                      btnOkCompletion: tapAlert, btnDetailCompletion: tapDetail, type: alertType)
            let claroAlert = ClaroAlertRouter.createModule(alertInfo: alertInfo)
            claroAlert.show()
        }
    }

//    func showAlertAccept(_ title: String? = nil,
//                         message: String?, alertType: AlertType = AlertType.info, tappAccept: tappAccept? = nil, tappCancel: tappCancel? = nil, needImage: Bool? = true) {
//        DispatchQueue.main.async {
//            let alertInfoAccept = AlertAceptInfo(title: title ?? alertType.defaultTitle, message: message, btnTitleCancel: nil, btnTitleAccept: nil, btnCancelCompletion: tappCancel, btnAcceptCompletion: tappAccept, type: alertType, needImage: needImage, isNormal: nil)
//            let claaroAlertAccept = ClaroAlertAcceptRouter.createModule(alertAceptInfo: alertInfoAccept)
//            claaroAlertAccept.showAccept(nil)
//
//        }
//    }
//
//    func showAlertPermission(title: String? = nil,
//                             message: String?, alertType: AlertType = AlertType.info, btnTitleCancel: String? = nil, btnTitleAccept: String? = nil, tappAccept: tappAccept? = nil, tappCancel: tappCancel? = nil, needImage: Bool? = true) {
//        DispatchQueue.main.async {
//            let alertInfoAccept = AlertAceptInfo(title: title, message: message, btnTitleCancel: btnTitleCancel, btnTitleAccept: btnTitleAccept, btnCancelCompletion: tappCancel, btnAcceptCompletion: tappAccept, type: alertType, needImage: needImage, isNormal: nil)
//            let claaroAlertAccept = AlertSettingsPermissionRouter.createModule(alertAceptInfo: alertInfoAccept)
//            claaroAlertAccept.showAccept(nil)
//
//        }
//    }
//
//    func showAlertAcceptCustom(_ title: String? = nil,
//                               message: String?, alertType: AlertType = AlertType.info, btnTitleCancel: String? = nil, btnTitleAccept: String? = nil, tappAccept: tappAccept? = nil, tappCancel: tappCancel? = nil, needImage: Bool? = true, isNormal: Bool? = false) {
//        DispatchQueue.main.async {
//            let alertInfoAccept = AlertAceptInfo(title: title ?? alertType.defaultTitle, message: message, btnTitleCancel: btnTitleCancel, btnTitleAccept: btnTitleAccept, btnCancelCompletion: tappCancel, btnAcceptCompletion: tappAccept, type: alertType, needImage: needImage, isNormal: isNormal)
//            let claaroAlertAccept = ClaroAlertAcceptRouter.createModule(alertAceptInfo: alertInfoAccept)
//            claaroAlertAccept.showAccept(nil)
//
//        }
//    }
//
//    func showAlertCloseModal(_ title: String? = nil,
//                                message: String?, alertType: AlertType = AlertType.info,
//                                onWindow: Bool? = nil,
//                                tapAlert: tappAccept? = nil, tapDetail: tappAccept? = nil) {
//        DispatchQueue.main.async {
//            let alertCloseModal = AlertInfo(title: title ?? "", message: message,
//                                      btnTitleOk: nil, btnTitleDetail: nil,
//                                      btnOkCompletion: tapAlert, btnDetailCompletion: tapDetail, type: alertType)
//            let claroAlert = ClaroAlertCloseXRouter.createModule(alertInfo: alertCloseModal, onWindow: onWindow)
//            claroAlert.show()
//        }
//
//    }

    func addChild(_ viewController: UIViewController, with frame: CGRect) {
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.view.frame = frame
        self.view.addSubview(viewController.view)
    }

    func removeControllerFromParent() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
}

public var vSpinner: UIView?

public extension UIViewController {
    func showSpinner(onView: UIView = UIApplication.window) {
        let spinnerView = UIView.init(frame: onView.bounds)
        DispatchQueue.main.async {
            spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.66)
            let lottieContainer = UIView()
            let lottie = LottieManager(animationName: "ClaroPaySpinner")
            lottie.play(on: lottieContainer, loopAnimation: true, animationSpeed: 1.25)
            spinnerView.addAutolayoutSubview(lottieContainer,
                                             matchingAttributes: [.centerX,.centerY])
            lottieContainer.heightAnchor.constraint(equalTo: lottieContainer.widthAnchor,
                                                    multiplier: 1.0).isActive = true
            lottieContainer.widthAnchor.constraint(equalTo: spinnerView.widthAnchor, multiplier: 200/375).isActive = true
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
        vSpinner?.tag = 101
    }
    
    func showSpinnerWithText(onView: UIView = UIApplication.window, text: String?) {
        let spinnerView = UIView.init(frame: onView.bounds)
        DispatchQueue.main.async {
            //Image background
            let background = UIImage(named: "spinnerBackground")
            var imageView : UIImageView!
            imageView = UIImageView(frame: spinnerView.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = spinnerView.center
            spinnerView.addSubview(imageView)
            spinnerView.sendSubviewToBack(imageView)
            
            //Label spinner
            let label = UILabel(frame: CGRect.zero)
            label.textAlignment = .center
            label.text = text
            label.textColor = .white
            label.font = UIFont(name: "Nunito", size: 12.0)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            spinnerView.addSubview(label)
            
            label.heightAnchor.constraint(equalToConstant: 100).isActive = true
            label.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: spinnerView.bottomAnchor, constant: -32).isActive = true
            label.leadingAnchor.constraint(equalTo: spinnerView.leadingAnchor, constant: 32).isActive = true
            
            //
            let lottieContainer = UIView()
            let lottie = LottieManager(animationName: "ClaroPaySpinner")
            lottie.play(on: lottieContainer, loopAnimation: true, animationSpeed: 1.25)
            spinnerView.addAutolayoutSubview(lottieContainer,
                                             matchingAttributes: [.centerX,.centerY])
            lottieContainer.heightAnchor.constraint(equalTo: lottieContainer.widthAnchor,
                                                    multiplier: 1.0).isActive = true
            lottieContainer.widthAnchor.constraint(equalTo: spinnerView.widthAnchor, multiplier: 200/375).isActive = true
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
        vSpinner?.tag = 101
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            //vSpinner?.removeFromSuperview()
            UIApplication.window.viewWithTag(101)?.removeFromSuperview()
            vSpinner = nil
        }
    }

    func removeTabBar() {
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.gestureRecognizers?.removeAll()
    }

    func setTabarforNavigationFlow() {
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)

    func setUpBlackNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white

    }

        let image = UIImage(named: "LogoHeaderClaroPay")
        let imgView  = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = true
        self.navigationItem.titleView = imgView

        guard let nav = navigationController else {return}
        let bannerWidth  = nav.navigationBar.frame.size.width
        let bannerHeight  = nav.navigationBar.frame.size.height
        let customView = UIView(frame: CGRect(x: 0.0, y: 0, width: bannerWidth / 3, height: bannerHeight))
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "back_arrow"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 10, width: 20, height: 20)
        button.addTarget(self, action: #selector(returnView), for: .touchUpInside)
        customView.addSubview(button)

        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationController?.navigationBar.tintColor = .white
    }

    @objc func returnView() {
        _ = self.navigationController?.viewControllers.popLast()
    }
}
