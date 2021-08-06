//
//  DeleteCommentProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 27/07/21.
//

import Foundation

struct DeleteCommentProvider: ProviderPostProtocol {
    typealias Request = DeleteCommentRequestModel
    typealias Response = DeleteCommentResponseModel
    
    var idComment: Int
    
    init(idComment: Int) {
        self.idComment = idComment
    }
    
    func doAction(request: DeleteCommentRequestModel, response: @escaping (DeleteCommentResponseModel?, AppError?) -> Void) {
        SecureRequestDeleteProvider<DeleteCommentRequestModel, DeleteCommentResponseModel>(url: ApiUrlStatic.deleteComment(idComment: idComment))
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
