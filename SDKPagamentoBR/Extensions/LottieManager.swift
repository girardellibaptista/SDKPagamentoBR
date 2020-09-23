//
//  LottieManager.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 04/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation
import Lottie
import UIKit

public class LottieManager {
    
    // MARK: - PROPERTIES
    private var animationName: String
    
    // MARK: - INITIALIZERS
    public init(animationName: String) {
        self.animationName = animationName
    }
    
    // MARK: - METHODS
    public func play(on view: UIView, loopAnimation: Bool = false,
              animationSpeed: CGFloat = 1, completionBlock: (() -> Void)? = nil,
              removeFromSuperview: Bool = true) {
        let lottieView = AnimationView(name: animationName)
        lottieView.loopMode = loopAnimation ? .loop : .playOnce
        lottieView.animationSpeed = animationSpeed
        
        view.addAutolayoutSubview(lottieView,
                                  matchingAttributes: [.top,.bottom,.leading,.trailing])
        
        lottieView.play { _ in
            completionBlock?()
            removeFromSuperview ? lottieView.removeFromSuperview() : ()
        }
    }
}
