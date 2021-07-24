//
//  MaterialModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import RealmSwift

class MaterialModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var picture: String?
    @objc dynamic var desc: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var courseId: String?
    @objc dynamic var courseName: String?
    var chapterShorts = List<ChapterShortModel>()
    
    enum CodingKeys: String, CodingKey {
        case id = "materiId"
        case name = "materiName"
        case picture
        case desc = "description"
        case createdAt
        case updatedAt
        case courseId = "brevetId"
        case courseName = "brevetName"
        case chapterShorts = "chapter"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}

class ChapterShortModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var materialId: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case materialId = "materiId"
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
