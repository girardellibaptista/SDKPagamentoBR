//
//  ClaroAlertInteractor.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit

class ClaroAlertInteractor: ClaroAlertInteractorProtocol {

    weak var presenter: ClaroAlertPresenterProtocol?

    func willPostPushIfPending() {
        NotificationCenter.default.post(name: Notification.Name.presentPush, object: nil)
    }
}
