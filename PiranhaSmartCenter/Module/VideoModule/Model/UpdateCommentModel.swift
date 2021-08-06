//
//  UpdateCommentModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 26/07/21.
//

import Foundation

struct UpdateCommentRequestModel: Codable, RequestProtocol {
    var videoId: String
    var parentId: String
    var comment: String
}

struct UpdateCommentResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
