//
//  String+Extension.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 15/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation

public extension String {
    
    func currencyInputFormat(decimals: Int = 2, minimumDecimals: Int = 0, customString: String? = nil) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$"
        formatter.maximumFractionDigits = decimals
        if let decimalString = self.getDecimalString(), minimumDecimals == 0 {
            formatter.minimumFractionDigits = decimalString.count
        } else {
            formatter.minimumFractionDigits = minimumDecimals
        }
        formatter.locale = Locale(identifier: "pt_BR")

        number = NSNumber(value: self.toDouble())
        
        if let customString = customString, number == 0 as NSNumber {
            return customString
        }

        if let string = formatter.string(from: number) {
            return string
        } else {
            return ""
        }
    }
}
