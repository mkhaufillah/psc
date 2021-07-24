//
//  ProfileModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

struct ProfileResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ProfileDataModel?
    let version: String?
    let statusCode: Int?
    let data: ProfileDataModel?
}

class ProfileDataModel: Object, Codable {
    var data = List<UserModel>()
}
