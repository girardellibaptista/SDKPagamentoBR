//
//  SendMoneyEditViewController.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 16/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import ClaroPayStyle

open class SendMoneyEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputValue: CurrencyField!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var saldoValue: UILabel!
    @IBOutlet weak var txtSaldo: UILabel!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var btnConfirm: ClaroButton!
    @IBOutlet weak var imgEye: UIImageView!
    @IBOutlet weak var btnEditValor: ClaroButton!
    @IBOutlet weak var hideSaldoView: UIView!
    
    var dataTransf: DataTransfer = DataTransfer()
    var balance: Balance = Balance()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputValue.delegate = self
        self.inputValue.addTarget(self, action: #selector(inputValueDidChange), for: .editingChanged)
        self.inputValue.textColor = UIColor(hexString: "#838383")
        self.inputValue.font =  ClaroPayFont.bold.font(size: .xxxlarger35)
        self.inputValue.locale = Locale(identifier: "pt_BR")
        self.inputValue.textAlignment = .center

        
        self.vwCard.layer.addShadow()
        self.btnConfirm.applyUIFormat(withTitle: "Avançar", isEnabled: false, disabledStyle: .gray)
        self.btnConfirm.addTarget(self, action: #selector(didTapConfirm(_:)), for: .touchUpInside)
        self.imgEye.image = UIImage(named: "hideIcon",in: Bundle(for: SendMoneyConfirmationViewController.self),compatibleWith: nil)
        self.txtSaldo.textColor = UIColor(hexString: "#50626C")
        self.hideSaldoView.backgroundColor = UIColor(hexString: "#E6E6E6")
        self.btnEditValor.setWhiteStyle()
        self.btnEditValor.setTitle("Inserir valor", for: .normal)
        self.btnEditValor.layer.cornerRadius = 5.0
        self.btnEditValor.layer.roundCorners(radius: self.btnEditValor.bounds.height / 2)
        self.btnEditValor.isEnabled = false
        self.btnEditValor.layer.borderColor = UIColor(hexString: "#E6E6E6")?.cgColor
        self.btnEditValor.setTitleColor(UIColor(hexString: "#E6E6E6"), for: .normal)
        self.saldoValue.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgEye.isUserInteractionEnabled = true
        imgEye.addGestureRecognizer(tapGestureRecognizer)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == inputValue {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
    @objc func inputValueDidChange() {
        self.dataTransf.amount = "\(inputValue.decimal)"
//        print("currencyField:",inputValue.text!)
//        print("decimal:", inputValue.decimal)
//        print("doubleValue:",(inputValue.decimal as NSDecimalNumber).doubleValue, terminator: "\n\n")
        
        self.btnConfirm.isEnabled = (inputValue.decimal as NSDecimalNumber).doubleValue > 0.00
        
        
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
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @objc func didTapConfirm(_ sender: UIButton) {
        self.returnToSendMoney()
    }
    
    func returnToSendMoney() {
        let view = SendMoneyConfirmationViewController(nibName: "SendMoneyConfirmationViewController", bundle: Bundle(for: SendMoneyConfirmationViewController.self))
        view.dataTransf = self.dataTransf
        self.navigationController?.pushViewController(view, animated: true)
    }

}
