//
//  DataTransfer.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 14/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit

public class DataTransfer: NSObject {
    
    var destination: String?
    var amount: String?
    var desc: String?
    var document: String?
    var paymentMetod: String?
    var editAmountEnable: Bool = false
    var pagador: String?
    var docPagador: String?
    var dtTransacao: String?
    var codigoAutenticacao: String?
    

    override init() {
        destination = ""
        amount = "0,00"
        desc = ""
        document = ""
        paymentMetod = ""
        editAmountEnable = false
        pagador = ""
        docPagador = ""
        dtTransacao = ""
        codigoAutenticacao = ""
        super.init()
    }

}
