//
//  InAppPurchaseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/08/21.
//

import Foundation

struct InAppPurchaseRequestModel: Codable, RequestProtocol {
    var token: String
    var status: String
    var pcode: String
}

struct InAppPurchaseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
