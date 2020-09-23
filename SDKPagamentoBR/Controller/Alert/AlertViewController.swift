//
//  AlertViewController.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import ClaroPayStyle

open class AlertViewController: UIViewController, ClaroAlertViewProtocol {

    @IBOutlet weak var vwDialog: UIView!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var imgVwIcon: UIImageView!
    @IBOutlet weak var btnOk: ClaroButton!
    @IBOutlet weak var btnNok: ClaroButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var topLogoConstraint: NSLayoutConstraint!
    
    var presenter: ClaroAlertPresenterProtocol?
    var btnImage : UIButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }
    
    func configView() {
        self.vwDialog.layer.roundCorners(radius: 5)
        self.willChangeProperties()
        self.btnOk.applyUIFormat(withTitle: "Ler novamente", isEnabled: true, disabledStyle: .gray)
        self.btnNok.setWhiteStyle()
        self.btnNok.setTitle("Sair", for: .normal)
        self.btnNok.layer.cornerRadius = 5.0
        self.btnNok.layer.roundCorners(radius: self.btnNok.bounds.height / 2)
        self.btnOk.addTarget(self, action: #selector(didTapOkButton(_:)), for: .touchUpInside)
        self.btnNok.addTarget(self, action: #selector(didTapDetailButton(_:)), for: .touchUpInside)
        self.presenter?.willBindView()
    }
    
    public func show() {
        presenter?.willShowAlert()
    }
    
    func willChangeProperties() {
        self.vwDialog.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        self.imgVwIcon.transform = self.vwDialog.transform
        self.vwBackground.alpha = 0.0
    }
    
    @objc func didTapOkButton(_ sender: UIButton) {
        presenter?.notifyDidTapOk()
    }

    @objc func didTapDetailButton(_ sender: UIButton) {
        presenter?.notifyDidTapDetail()
    }
    
    func willRestoreProperties() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.vwBackground.alpha = 0.66
            self?.vwDialog.transform = CGAffineTransform.identity
            self?.imgVwIcon.transform = CGAffineTransform.identity
        }
    }

    func willDissappear(isDetail: Bool) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.vwBackground.alpha = 0
            self?.vwDialog.alpha = 0
            self?.imgVwIcon.alpha = 0
        }, completion: { [weak self] _ in
            self?.presenter?.notifyAnimationDidEnd(isDetail: isDetail)
        })
    }

   public func willSetProperties(title: String?, message: String?, type: AlertType, btnTitleOk: String?, btnTitleDetail: String?, attributtedMessage: NSMutableAttributedString?) {
        self.imgVwIcon.image = UIImage(named: "infoIcon",in: Bundle(for: AlertViewController.self),compatibleWith: nil)
        if type == AlertType.error || type == AlertType.success || type == AlertType.info{
            btnImage = UIButton()
            btnImage.backgroundColor = .clear
            btnImage.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
            btnImage.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(btnImage)
            btnImage.leftAnchor.constraint(equalTo: imgVwIcon.leftAnchor).isActive = true
            btnImage.rightAnchor.constraint(equalTo: imgVwIcon.rightAnchor).isActive = true
            btnImage.topAnchor.constraint(equalTo: imgVwIcon.topAnchor).isActive = true
            btnImage.bottomAnchor.constraint(equalTo: imgVwIcon.bottomAnchor).isActive = true
        }
        if type == .none {
            topLogoConstraint?.constant = 0.0
        }
        self.lblTitle.text = title
        self.lblTitle.font = UIFont(name: ClaroPayFont.nunitoBold.rawValue,
                                    size: 22.0.getDynamicSize())
        //self.btnDetail.isHidden = false
        if let titleOk = btnTitleOk {
            UIView.setAnimationsEnabled(false)
            self.btnOk.setTitle(titleOk, for: .normal)
            UIView.setAnimationsEnabled(true)
        }
//        if let titleDetail = btnTitleDetail {
//            self.btnDetail.setTitle(titleDetail, for: .normal)
//        }
    
        if let attributtedMessage = attributtedMessage {
            self.lblMessage.attributedText = attributtedMessage
        } else {
            self.lblMessage.text = message
            self.lblMessage.font = UIFont(name: ClaroPayFont.regular.rawValue,
                                          size: 12.0.getDynamicSize())
        }
    }
    
    @objc func tapClose() {
        presenter?.notifyDidTapOk()
    }

}
