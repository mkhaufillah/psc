//
//  ErrorModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/07/21.
//

// Error type 1
struct Error1ResponseModel: Codable, ResponseProtocol {
    typealias DataModel = Error1DataModel
    let statusCode: Int?
    let data: Error1DataModel
}

struct Error1DataModel: Codable {
    let errors: Error1Model?
}

struct Error1Model: Codable {
    let code: String?
    let messages: Array<String>?
}

// Error type 2
struct Error2ResponseModel: Codable, ResponseProtocol {
    typealias DataModel = Error2DataModel
    let statusCode: Int?
    let data: Error2DataModel
}

struct Error2DataModel: Codable {
    let errors: Error2Model?
}

struct Error2Model: Codable {
    let code: String?
    let messages: Array<Array<String>>?
}
