//
//  QRScanViewController.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import ClaroPayStyle

class QRScanViewController: UIViewController {
    
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var btnInfo: ClaroButton!
    @IBOutlet weak var marginTop: UIImageView!
    @IBOutlet weak var marginBottom: UIImageView!
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var dataTransf: DataTransfer = DataTransfer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblScan.text = "Posicione o QR Code dentro do espaço para\nque seja lido corretamente"
        self.lblScan.textColor = UIColor(red: 0.5137, green: 0.5137, blue: 0.5137, alpha: 1.0)
        self.marginTop.image = UIImage(named: "marginTop")
        self.marginBottom.image = UIImage(named: "marginBottom")
        self.btnInfo.addImage(image: UIImage(named: "interogationIcon",in: Bundle(for: QRScanViewController.self),compatibleWith: nil),
        imageHeight: UIScreen.main.bounds.width / 375 * 18,
        tintColor: nil)
        self.vwCard.layer.addShadow()
        self.vwCard.layer.roundCorners(radius: 5)
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scannerView.checkCameraStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
}


extension QRScanViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        //let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        //scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        presentAlert(withTitle: "QR Code", message: str ?? "")
    }
    
    func showSimpleAlert(alert: UIAlertController){
     self.present(alert, animated: true, completion: nil)
    }
    
    func show() {
        showModalAlert("Transação não concluída.\nQR Code inválido", message: "", alertType: .info, btnTitleOk: "Ler novamente", btnTitleDetail: "Sair", onWindow: nil, tapAlert: {
            //self.scannerView.startScanning()
            //self.navigationController?.popViewController(animated: true)
            
            self.dataTransf.destination = "John Doe da Silva"
            self.dataTransf.amount = "0.00"
            self.dataTransf.desc = "Viagem fim de semana"
            self.dataTransf.paymentMetod = "Saldo na carteira"
            self.dataTransf.document = "222.333.444-55"
            
            self.navigateToConfirmartion()
        }, tapDetail: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func navigateToConfirmartion() {
        let view = SendMoneyConfirmationViewController(nibName: "SendMoneyConfirmationViewController", bundle: Bundle(for: SendMoneyConfirmationViewController.self))
        view.dataTransf = self.dataTransf
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}

