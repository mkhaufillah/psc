//
//  GetResultExerciseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct GetResultExerciseProvider: ProviderGetProtocol {
    typealias Response = GetResultExerciseResponseModel
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func doAction(response: @escaping (GetResultExerciseResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<GetResultExerciseResponseModel>(url: "\(ApiUrlStatic.resultExercise)?page=\(page)")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
