//
//  RecapCourseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 24/07/21.
//

import Foundation

struct RecapCourseProvider: ProviderGetProtocol {
    typealias Response = RecapCourseResponseModel
    
    func doAction(response: @escaping (RecapCourseResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<RecapCourseResponseModel>(url: ApiUrlStatic.recapCourse)
            .doAction() { res, err in
                response(res, err)
            }
    }
}

