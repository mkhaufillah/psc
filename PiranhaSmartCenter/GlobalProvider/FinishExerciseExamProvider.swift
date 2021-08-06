//
//  FinishExerciseExamProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct FinishExerciseExamProvider: ProviderPostProtocol {
    typealias Request = FinishExamExerciseRequestModel
    typealias Response = FinishExamExerciseResponseModel
    
    func doAction(request: FinishExamExerciseRequestModel, response: @escaping (FinishExamExerciseResponseModel?, AppError?) -> Void) {
        SecureRequestPostProvider<FinishExamExerciseRequestModel, FinishExamExerciseResponseModel>(url: ApiUrlStatic.finishExerciseExam)
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
