//
//  PostAnswerExerciseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation

struct PostAnswerExerciseProvider: ProviderPostProtocol {
    typealias Request = PostAnswerQuestionRequestModel
    typealias Response = PostAnswerQuestionResponseModel
    
    func doAction(request: PostAnswerQuestionRequestModel, response: @escaping (PostAnswerQuestionResponseModel?, AppError?) -> Void) {
        SecureRequestPostProvider<PostAnswerQuestionRequestModel, PostAnswerQuestionResponseModel>(url: ApiUrlStatic.postAnswerExercise)
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
