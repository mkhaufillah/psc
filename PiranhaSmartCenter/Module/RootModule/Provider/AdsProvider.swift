//
//  AdsProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 28/08/21.
//

import Foundation

struct AdsProvider: ProviderGetProtocol {
    typealias Response = AdsResponseModel
    
    func doAction(response: @escaping (AdsResponseModel?, AppError?) -> Void) {
        RequestGetProvider<AdsResponseModel>(url: ApiUrlStatic.ads)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
