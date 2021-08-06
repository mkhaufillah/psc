//
//  ExcerciseQuestionProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct ExerciseQuestionProvider: ProviderGetProtocol {
    typealias Response = ExerciseResponseModel
    
    var idMaterial: Int
    
    init(idMaterial: Int) {
        self.idMaterial = idMaterial
    }
    
    func doAction(response: @escaping (ExerciseResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<ExerciseResponseModel>(url: "\(ApiUrlStatic.multipleExerciseQuestion(idMaterial: idMaterial))", isConvertToSnackCase: false)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
