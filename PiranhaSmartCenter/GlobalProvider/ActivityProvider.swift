//
//  ActivityProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct ActivityProvider: ProviderGetProtocol {
    typealias Response = ActivityResponseModel
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func doAction(response: @escaping (ActivityResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<ActivityResponseModel>(url: "\(ApiUrlStatic.activity)?page=\(page)")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
