//
//  RegisterModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import Foundation

struct RegisterRequestModel: Codable, RequestProtocol {
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case cPassword
        case gender
        case picture
        case address
        case birthdate = "birthday"
        case referenceId
        case detailReferenceEtc
        case education
    }
}

struct RegisterResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
