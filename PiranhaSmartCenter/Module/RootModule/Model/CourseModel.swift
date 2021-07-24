//
//  CourseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

struct CourseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = CourseDataModel?
    let version: String?
    let statusCode: Int?
    let data: CourseDataModel?
}

class CourseDataModel: Object, Codable {
    var data = List<CourseModel>()
}

class CourseModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    var materialShorts = List<MaterialShortModel>()
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt
        case updatedAt
        case materialShorts = "materi"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}

class MaterialShortModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var picture: String?
    @objc dynamic var courseId: String?
    @objc dynamic var desc: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
        case courseId = "brevetId"
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
