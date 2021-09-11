//
//  RefenceCodeModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/09/21.
//

import RealmSwift

struct ReferenceCodeResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ReferenceCodeDataModel?
    let version: String?
    let statusCode: Int?
    let data: ReferenceCodeDataModel?
}

class ReferenceCodeDataModel: Object, Codable {
    var data = List<ReferenceCodeModel>()
}

class ReferenceCodeModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var code: String?
    @objc dynamic var desc: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case desc = "description"
        case createdAt
        case updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
