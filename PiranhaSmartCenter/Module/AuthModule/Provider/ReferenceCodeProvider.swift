//
//  ReferenceCodeProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/09/21.
//

import Foundation

struct ReferenceCodeProvider: ProviderGetProtocol {
    typealias Response = ReferenceCodeResponseModel
    
    func doAction(response: @escaping (ReferenceCodeResponseModel?, AppError?) -> Void) {
        RequestGetProvider<ReferenceCodeResponseModel>(url: "\(ApiUrlStatic.codeReference)")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
