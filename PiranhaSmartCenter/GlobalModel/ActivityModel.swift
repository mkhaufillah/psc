//
//  ActivityModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

struct ActivityResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ActivityDataModel?
    let version: String?
    let statusCode: Int?
    let data: ActivityDataModel?
}

class ActivityDataModel: Object, Codable {
    var data = List<ActivityModel>()
    @objc dynamic var pagination: PaginationModel?
}

class ActivityModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var dateEvent: String?
    @objc dynamic var photo: String?
    @objc dynamic var desc: String?
    @objc dynamic var decodeDescription: String?
    @objc dynamic var attachment: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dateEvent
        case photo
        case desc = "description"
        case decodeDescription
        case attachment
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
