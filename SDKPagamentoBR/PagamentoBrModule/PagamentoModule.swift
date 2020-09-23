//
//  PagamentoModule.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 05/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation
import UIKit

public class PagamentoModule: NSObject {
    
    
    public override init() {
        super.init()
    }
    
    
    
    public func presentScanQR() -> UIViewController {
        let scanQRView = QRScanViewController(nibName: "QRScanViewController", bundle: Bundle(for: QRScanViewController.self))
        
        return scanQRView
    }
    
    public func createAlertView() -> AlertViewController {
        let alertView = AlertViewController(nibName: "AlertViewController", bundle: Bundle(for: AlertViewController.self))
        return alertView
    }
    
    public func createSendMoneyConfirmationView() -> SendMoneyEditViewController {
           let alertView = SendMoneyEditViewController(nibName: "SendMoneyEditViewController", bundle: Bundle(for: SendMoneyEditViewController.self))
           return alertView
       }
}
