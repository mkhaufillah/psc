//
//  UpdateCommentProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 27/07/21.
//

import Foundation

struct UpdateCommentProvider: ProviderPostProtocol {
    typealias Request = UpdateCommentRequestModel
    typealias Response = UpdateCommentResponseModel
    
    var idComment: Int
    
    init(idComment: Int) {
        self.idComment = idComment
    }
    
    func doAction(request: UpdateCommentRequestModel, response: @escaping (UpdateCommentResponseModel?, AppError?) -> Void) {
        SecureRequestPostProvider<UpdateCommentRequestModel, UpdateCommentResponseModel>(url: ApiUrlStatic.updateComment(idComment: idComment))
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
