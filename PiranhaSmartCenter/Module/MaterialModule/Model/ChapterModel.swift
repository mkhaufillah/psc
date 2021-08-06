//
//  ChapterModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 24/07/21.
//

import RealmSwift

struct ChapterResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ChapterDataModel?
    let version: String?
    let statusCode: Int?
    let data: ChapterDataModel?
}

class ChapterDataModel: Object, Codable {
    var data = List<ChapterModel>()
    @objc dynamic var pagination: PaginationModel?
}

class ChapterModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var chapterName: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var courseId: String?
    @objc dynamic var courseName: String?
    @objc dynamic var materialId: String?
    @objc dynamic var materialName: String?
    @objc dynamic var materialPicture: String?
    @objc dynamic var materialDescription: String?
    var videos = List<ShortVideoModel>()
    
    enum CodingKeys: String, CodingKey {
        case id = "chapterId"
        case chapterName
        case createdAt
        case updatedAt
        case courseId = "brevetId"
        case courseName = "brevetName"
        case materialId = "materiId"
        case materialName = "materiName"
        case materialPicture = "materiPicture"
        case materialDescription = "materiDescription"
        case videos
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}

class ShortVideoModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var path: String?
    @objc dynamic var chapterId: String?
    @objc dynamic var totalViews: String?
    @objc dynamic var videoType: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var logId: String?
    @objc dynamic var viewed: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case path
        case chapterId
        case totalViews
        case videoType
        case createdAt
        case updatedAt
        case logId
        case viewed
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
