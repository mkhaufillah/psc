//
//  CourseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct CourseProvider: ProviderGetProtocol {
    typealias Response = CourseResponseModel
    
    func doAction(response: @escaping (CourseResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<CourseResponseModel>(url: ApiUrlStatic.course)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
