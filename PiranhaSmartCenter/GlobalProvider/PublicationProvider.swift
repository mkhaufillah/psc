//
//  PublicationProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct PublicationProvider: ProviderGetProtocol {
    typealias Response = PublicationResponseModel
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func doAction(response: @escaping (PublicationResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<PublicationResponseModel>(url: "\(ApiUrlStatic.publication)?page=\(page)")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
