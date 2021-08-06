//
//  BankProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation

struct BankProvider: ProviderGetProtocol {
    typealias Response = BankResponseModel
    
    func doAction(response: @escaping (BankResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<BankResponseModel>(url: ApiUrlStatic.listBank)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
