//
//  UINavigationController+Extension.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 16/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import UIKit
import Foundation

extension UINavigationController {

   func backToViewController(vc: Any) {
      for element in viewControllers as Array {
        if "\(type(of: element)).Type" == "\(type(of: vc))" {
            self.popToViewController(element, animated: true)
            break
         }
      }
   }

}
