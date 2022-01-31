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
    // New fields 31 January 2022
    var nik: String
    var religion: String
    var birthPlace: String
    var provinceId: Int
    var cityId: Int
    var districtId: Int
    var villageId: Int
    var nameMother: String
    var nameFather: String
}

struct RegisterResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}
