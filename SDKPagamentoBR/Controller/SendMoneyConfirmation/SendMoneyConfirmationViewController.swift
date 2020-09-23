//
//  SendMoneyConfirmationViewController.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 11/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import ClaroPayStyle

class SendMoneyConfirmationViewController: UIViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var amoutTxt: UILabel!
    @IBOutlet weak var saldoValue: UILabel!
    @IBOutlet weak var txtSaldo: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet var vwSeparators: [UIView]!
    @IBOutlet weak var btnConfirm: ClaroButton!
    @IBOutlet weak var imgEye: UIImageView!
    @IBOutlet weak var btnEditValor: ClaroButton!
    @IBOutlet weak var hideSaldoView: UIView!
    @IBOutlet weak var recebedorLabel: UILabel!
    @IBOutlet weak var recebedorTxt: UILabel!
    @IBOutlet weak var documentoLabel: UILabel!
    @IBOutlet weak var documentoTxt: UILabel!
    @IBOutlet weak var metodoPagamentoLabel: UILabel!
    @IBOutlet weak var metodoPagamentoTxt: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var descricaoTxt: UILabel!
    
    var dataTransf: DataTransfer = DataTransfer()
    var balance: Balance = Balance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwCard.layer.addShadow()
        self.btnConfirm.applyUIFormat(withTitle: "Avançar", isEnabled: true, disabledStyle: .gray)
        self.btnConfirm.addTarget(self, action: #selector(didTapConfirm(_:)), for: .touchUpInside)
        self.imgEye.image = UIImage(named: "hideIcon",in: Bundle(for: SendMoneyConfirmationViewController.self),compatibleWith: nil)
        self.txtSaldo.textColor = UIColor(hexString: "#50626C")
        self.hideSaldoView.backgroundColor = UIColor(hexString: "#E6E6E6")
        self.btnEditValor.setWhiteStyle()
        
        self.btnEditValor.setTitle("Editar valor", for: .normal)
        self.btnEditValor.layer.cornerRadius = 5.0
        self.btnEditValor.isEnabled = true
        self.btnEditValor.layer.roundCorners(radius: self.btnEditValor.bounds.height / 2)
        self.btnEditValor.layer.borderColor = UIColor(hexString: "#E6E6E6")?.cgColor
        self.btnEditValor.setTitleColor(UIColor(hexString: "#E6E6E6"), for: .normal)
        self.saldoValue.isHidden = true
        self.recebedorLabel.textColor = UIColor(hexString: "#50626C")
        self.documentoLabel.textColor = UIColor(hexString: "#50626C")
        self.metodoPagamentoLabel.textColor = UIColor(hexString: "#50626C")
        self.descricaoLabel.textColor = UIColor(hexString: "#50626C")
        self.recebedorTxt.text = self.dataTransf.destination
        self.documentoTxt.text = self.dataTransf.document
        self.metodoPagamentoTxt.text = self.dataTransf.paymentMetod
        self.descricaoTxt.text = self.dataTransf.desc
        self.validateAmount()
        self.getBalance()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgEye.isUserInteractionEnabled = true
        imgEye.addGestureRecognizer(tapGestureRecognizer)
        
        self.vwSeparators.forEach {
            $0.layoutIfNeeded()
            $0.addDottedLine(inPosition: (CGPoint(x: 0.0, y: $0.bounds.height),
                                          CGPoint(x: $0.bounds.width, y: $0.bounds.height)),
                             strokeColor: UIColor(red: 205, green: 205, blue: 205),
                             lineWidth: 1.0, linePattern: nil)
        }
    }
    
    private func validateAmount() {
        let amount = self.dataTransf.amount?.currencyInputFormat(decimals: 2, minimumDecimals: 2)
        self.amoutTxt.text = "\(amount ?? "R$ 0,00")"
        
        
        if(self.dataTransf.amount == nil || self.dataTransf.amount == "" || self.dataTransf.amount == "0.00" || self.dataTransf.amount == "0,00" || self.dataTransf.editAmountEnable) {
            self.dataTransf.editAmountEnable = true
            self.pageTitle.text = "QUANTO DESEJA PAGAR?"
            self.pageTitle.textColor = UIColor(hexString: "#FF3A47")
            self.btnEditValor.layer.borderColor = UIColor(hexString: "#50626C")?.cgColor
            self.btnEditValor.setTitleColor(UIColor(hexString: "#50626C"), for: .normal)
            self.btnEditValor.addTarget(self, action: #selector(didTapEdit(_:)), for: .touchUpInside)
        }
        
        self.btnEditValor.isEnabled = self.dataTransf.editAmountEnable
        
    }
    
    private func getBalance() {
        self.balance.amount = "1000.00"
        self.saldoValue.text = "\(self.balance.amount?.currencyInputFormat(decimals: 2, minimumDecimals: 2) ?? "R$ 0,00")"
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.saldoValue.isHidden = !self.saldoValue.isHidden
        
        if(self.saldoValue.isHidden) {
           self.hideSaldoView.backgroundColor = UIColor(hexString: "#E6E6E6")
             self.imgEye.image = UIImage(named: "hideIcon",in: Bundle(for: SendMoneyConfirmationViewController.self),compatibleWith: nil)
        }else {
            self.hideSaldoView.backgroundColor = UIColor(white: 1, alpha: 0.5)
             self.imgEye.image = UIImage(named: "showIcon",in: Bundle(for: SendMoneyConfirmationViewController.self),compatibleWith: nil)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @objc func didTapConfirm(_ sender: UIButton) {
        showModalAlert("Você não tem saldo para realizar essa transação", message: "", alertType: .info, btnTitleOk: "Fazer depósito", btnTitleDetail: "Sair", onWindow: nil, tapAlert: {
            
            self.dataTransf.destination = "John Doe da Silva"
            self.dataTransf.amount = "150.00"
            self.dataTransf.desc = "Viagem fim de semana"
            self.dataTransf.paymentMetod = "Saldo na carteira"
            self.dataTransf.document = "222.333.444-55"
            
            self.navigateToReceipt()
        }, tapDetail: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func didTapEdit(_ sender: UIButton) {
        self.navigateToEditValue()
    }
    
    func navigateToEditValue() {
        let view = SendMoneyEditViewController(nibName: "SendMoneyEditViewController", bundle: Bundle(for: SendMoneyEditViewController.self))
        view.dataTransf = self.dataTransf
        view.balance = self.balance
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func navigateToReceipt() {
        
        self.dataTransf.pagador = "Marcelo Xavier"
        self.dataTransf.docPagador = "111.222.333-44"
        self.dataTransf.codigoAutenticacao = "2Q2M-b4UDp-3922x-UHP-MuFf-3922x-b4UDp"
        self.dataTransf.dtTransacao = "22/10/2020 16:09"
        
        let view = SendMoneyReceiptViewController(nibName: "SendMoneyReceiptViewController", bundle: Bundle(for: SendMoneyReceiptViewController.self))
        view.dataTransf = self.dataTransf
        self.navigationController?.pushViewController(view, animated: true)
    }
}
