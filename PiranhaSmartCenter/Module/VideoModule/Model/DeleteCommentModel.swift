//
//  DeleteCommentModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 26/07/21.
//

import Foundation

struct DeleteCommentRequestModel: Codable, RequestProtocol {
}

struct DeleteCommentResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
