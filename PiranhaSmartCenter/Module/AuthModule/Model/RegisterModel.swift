//
//  RegisterModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import Foundation

struct RegisterRequestModel: RequestProtocol {
    var name: String
    var email: String
    var password: String
    var cPassword: String
    var gender: String
    var picture: Data
    var address: String
    var birthdate: String
    var referenceId: String
    var detailReferenceEtc: String
    var education: String
    var codeRefId: String
}

struct RegisterResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
