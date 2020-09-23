//
//  ClaroAlertPresenter.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.

import UIKit

class ClaroAlertPresenter: ClaroAlertPresenterProtocol {

    // MARK: - VARIABLES
    weak private var view: ClaroAlertViewProtocol?
    var interactor: ClaroAlertInteractorProtocol?
    private let router: ClaroAlertWireframeProtocol

    var alertInfo: AlertInfo!
    var onWindow: Bool?

    init(interface: ClaroAlertViewProtocol, interactor: ClaroAlertInteractorProtocol?, router: ClaroAlertWireframeProtocol, onWindow: Bool? = nil) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        self.onWindow = onWindow
    }

    // MARK: - METHODS
    func setAlertInfo(_ alertInfo: AlertInfo) {
        self.alertInfo = alertInfo
    }

    // MARK: - PRESENTER PROTOCOL
    func willBindView() {
        view?.willSetProperties(title: alertInfo.title,
                                message: alertInfo.message,
                                type: alertInfo.type,
                                btnTitleOk: alertInfo.btnTitleOk,
                                btnTitleDetail: alertInfo.btnTitleDetail,
                                attributtedMessage: alertInfo.attributtedMessage)
    }

    func notifyAnimationDidEnd(isDetail: Bool) {
        router.willRemoveAlert()
        isDetail ? alertInfo.btnDetailCompletion?() : alertInfo.btnOkCompletion?()
        interactor?.willPostPushIfPending()
    }

    func willShowAlert() {
        router.willAddAlert(onWindow: onWindow)
        view?.willRestoreProperties()
    }

    func notifyDidTapOk() {
        view?.willDissappear(isDetail: false)
    }

    func notifyDidTapDetail() {
        view?.willDissappear(isDetail: true)
    }
}
