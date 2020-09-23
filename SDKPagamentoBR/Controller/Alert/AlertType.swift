//
//  TypeAlert.swift
//  SDKPagamentoBR
//
//  Created by Camilo Oscar Girardelli Baptista on 08/09/20.
//  Copyright © 2020 ClaroPay. All rights reserved.
//

import Foundation

public enum AlertType {
    case success
    case connectionError
    case error
    case info
    case asyncError
    case processing
    case none

    var imageName: String {
        switch self {
        case .success:                                      return "successAlertIcon"
        case .connectionError, .error, .asyncError:         return "errorAlertIcon"
        case .info:                                         return "infoAlertIcon"
        case .processing:                                   return "processingAlertIcon"
        case .none:                                         return ""
        }
    }

    var isAsynchronous: Bool {
        return self == .asyncError
    }

    var defaultTitle: String {
        switch self {
        case .success:      return "Sucesso"
        case .info:         return "Importante"
        case .processing:   return "Processando"
        case .error:   return "Erro"
        default:            return ""
        }
    }
}
