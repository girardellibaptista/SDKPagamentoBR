//
//  SendMoneyReceiptViewController.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 16/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import ClaroPayStyle

class SendMoneyReceiptViewController: UIViewController {
    
    @IBOutlet weak var dowloadView: UIView!
    @IBOutlet weak var compartilharView: UIView!
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet var vwSeparators: [UIView]!
    @IBOutlet weak var btnFinalizar: ClaroButton!
    @IBOutlet weak var txValor: UILabel!
    @IBOutlet weak var txDtTransacao: UILabel!
    @IBOutlet weak var txPagador: UILabel!
    @IBOutlet weak var txDocPagador: UILabel!
    @IBOutlet weak var txRecebador: UILabel!
    @IBOutlet weak var txDocRecebedor: UILabel!
    @IBOutlet weak var txMetodoPagamento: UILabel!
    @IBOutlet weak var txDescricao: UILabel!
    @IBOutlet weak var txCodigoAutenticacao: UILabel!
    
    var dataTransf: DataTransfer = DataTransfer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwCard.layer.addShadow()
        self.dowloadView.roundCorners([.bottomLeft, .topLeft], radius: 16)
        self.dowloadView.layer.borderWidth = 1
        self.dowloadView.layer.borderColor = UIColor(hexString: "#CDCDCD")?.cgColor
        
        self.compartilharView.roundCorners([.bottomRight, .topRight], radius: 16)
        self.compartilharView.layer.borderWidth = 1
        self.compartilharView.layer.borderColor = UIColor(hexString: "#CDCDCD")?.cgColor
        
        self.btnFinalizar.applyUIFormat(withTitle: "Finalizar", isEnabled: true, disabledStyle: .gray)
        self.btnFinalizar.addTarget(self, action: #selector(didTapConfirm(_:)), for: .touchUpInside)
        
        self.vwSeparators.forEach {
            $0.layoutIfNeeded()
            $0.addDottedLine(inPosition: (CGPoint(x: 0.0, y: $0.bounds.height),
                                          CGPoint(x: $0.bounds.width, y: $0.bounds.height)),
                             strokeColor: UIColor(red: 205, green: 205, blue: 205),
                             lineWidth: 1.0, linePattern: nil)
        }
        
        self.txValor.text = self.dataTransf.amount
        self.txDescricao.text = self.dataTransf.dtTransacao
        self.txPagador.text = self.dataTransf.pagador
        self.txDocPagador.text = self.dataTransf.docPagador
        self.txRecebador.text = self.dataTransf.destination
        self.txDocRecebedor.text = self.dataTransf.document
        self.txMetodoPagamento.text = self.dataTransf.paymentMetod
        self.txDescricao.text = self.dataTransf.desc
        self.txCodigoAutenticacao.text = self.dataTransf.codigoAutenticacao
        self.txDtTransacao.text = self.dataTransf.dtTransacao
        

    }
    
    @objc func didTapConfirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
