//
//  PostCommentProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 27/07/21.
//

import Foundation

struct PostCommentProvider: ProviderPostProtocol {
    typealias Request = PostCommentRequestModel
    typealias Response = PostCommentResponseModel
    
    func doAction(request: PostCommentRequestModel, response: @escaping (PostCommentResponseModel?, AppError?) -> Void) {
        SecureRequestPostProvider<PostCommentRequestModel, PostCommentResponseModel>(url: ApiUrlStatic.postComment)
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
