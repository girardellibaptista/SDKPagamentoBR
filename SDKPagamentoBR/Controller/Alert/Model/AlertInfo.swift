//
//  AlertInfo.swift
//  ClaroPay
//
//  Created by Diego Alan Montero Soriano on 6/17/19.
//  Copyright © 2019 CITI Value in Real Time. All rights reserved.
//

import Foundation

public struct AlertInfo {
   public typealias complation = (() -> Void)?
    // MARK: - VARIABLES
    public var title, message, btnTitleOk, btnTitleDetail: String?
    public var attributtedMessage: NSMutableAttributedString?
    public var btnOkCompletion, btnDetailCompletion: (() -> Void)?
    public var type: AlertType!

    public init(title: String?, message: String?, btnTitleOk: String?, btnTitleDetail: String?, btnOkCompletion: complation, btnDetailCompletion: complation, type: AlertType) {
        self.title = title
        self.message = message
        self.btnTitleOk = btnTitleOk
        self.btnTitleDetail = btnTitleDetail
        self.btnOkCompletion = btnOkCompletion
        self.btnDetailCompletion = btnDetailCompletion
        self.type = type
    }
}
