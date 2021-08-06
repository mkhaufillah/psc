//
//  GetAnswerExerciseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct GetAnswerExerciseProvider: ProviderGetProtocol {
    typealias Response = GetAnswerExerciseResponseModel
    
    var idExam: Int
    
    init(idExam: Int) {
        self.idExam = idExam
    }
    
    func doAction(response: @escaping (GetAnswerExerciseResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<GetAnswerExerciseResponseModel>(url: "\(ApiUrlStatic.getAnswerExercise(idExam: idExam))")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
