//
//  GetResultExamProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct GetResultExamProvider: ProviderGetProtocol {
    typealias Response = GetResultExamResponseModel
    
    func doAction(response: @escaping (GetResultExamResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<GetResultExamResponseModel>(url: "\(ApiUrlStatic.resultExam)")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
