//
//  SendInvoiceModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation

struct SendInvoiceRequestModel: RequestProtocol {
    var bankId: String
    var attachment: Data
}

struct SendInvoiceResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
