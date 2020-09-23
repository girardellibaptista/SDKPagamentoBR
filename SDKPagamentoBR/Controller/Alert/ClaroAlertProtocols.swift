//
//  ClaroAlertProtocols.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import Foundation
import UIKit

// MARK: Wireframe -
protocol ClaroAlertWireframeProtocol: class {
    func willAddAlert(onWindow: Bool?)
    func willRemoveAlert()
}
// MARK: Presenter -
protocol ClaroAlertPresenterProtocol: class {
    func willBindView()
    func willShowAlert()
    func notifyDidTapOk()
    func notifyDidTapDetail()
    func notifyAnimationDidEnd(isDetail: Bool)
}

// MARK: Interactor -
protocol ClaroAlertInteractorProtocol: class {

    var presenter: ClaroAlertPresenterProtocol? { get set }
    func willPostPushIfPending()
}

// MARK: View -
protocol ClaroAlertViewProtocol: class {

  var presenter: ClaroAlertPresenterProtocol? { get set }
    func willDissappear(isDetail: Bool)
    func willRestoreProperties()
    func willSetProperties(title: String?, message: String?, type: AlertType, btnTitleOk: String?, btnTitleDetail: String?, attributtedMessage: NSMutableAttributedString?)
}
