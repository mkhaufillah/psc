//
//  ExamQuestionProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct ExamQuestionProvider: ProviderGetProtocol {
    typealias Response = ExamResponseModel
    
    func doAction(response: @escaping (ExamResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<ExamResponseModel>(url: "\(ApiUrlStatic.multipleExamQuestion)", isConvertToSnackCase: false)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
