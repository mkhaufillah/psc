//
//  SignInModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import RealmSwift

struct SignInRequestModel: Codable, RequestProtocol {
    var email: String
    var password: String
}

struct SignInResponseModel: Codable, ResponseProtocol {
    typealias DataModel = SignInDataModel?
    let version: String?
    let statusCode: Int?
    let data: SignInDataModel?
}

class SignInDataModel: Object, Codable {
    @objc dynamic var user: UserModel?
    @objc dynamic var token: String?
    
    override static func primaryKey() -> String? {
        return "token"
    }
}
