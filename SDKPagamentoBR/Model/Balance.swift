//
//  Balance.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 15/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation

public class Balance: NSObject {
    
    var balanceType: String?
    var date: String?
    var amount: String?
    var accountId: String?
    
    override init() {
        balanceType = ""
        date = ""
        amount = "0.00"
        accountId = ""
    }

}
