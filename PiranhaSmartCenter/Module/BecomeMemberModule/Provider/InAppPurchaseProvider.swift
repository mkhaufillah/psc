//
//  InAppPurchaseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/08/21.
//

import Foundation

struct InAppPurchaseProvider: ProviderPostProtocol {
    typealias Response = InAppPurchaseResponseModel
    typealias Request = InAppPurchaseRequestModel
    
    func doAction(request: InAppPurchaseRequestModel, response: @escaping (InAppPurchaseResponseModel?, AppError?) -> Void) {
        SecureRequestPostProvider<InAppPurchaseRequestModel, InAppPurchaseResponseModel>(url: ApiUrlStatic.inAppPurchase)
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
