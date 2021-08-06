//
//  VideoModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 26/07/21.
//

import RealmSwift

struct VideoResponseModel: Codable, ResponseProtocol {
    typealias DataModel = VideoDataModel?
    let version: String?
    let statusCode: Int?
    let data: VideoDataModel?
}

class VideoDataModel: Object, Codable {
    var data = List<VideoModel>()
    @objc dynamic var pagination: PaginationModel?
}

class VideoModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var videoName: String?
    @objc dynamic var videoPath: String?
    @objc dynamic var totalViews: String?
    @objc dynamic var videoType: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var courseId = 0
    @objc dynamic var courseName: String?
    @objc dynamic var materialId = 0
    @objc dynamic var materialName: String?
    @objc dynamic var materialPicture: String?
    @objc dynamic var materialDescription: String?
    @objc dynamic var chapterId = 0
    @objc dynamic var chapterName: String?
    @objc dynamic var isViewed: String?
    var comments = List<CommentModel>()
    
    enum CodingKeys: String, CodingKey {
        case id = "videoId"
        case videoName
        case videoPath
        case totalViews
        case videoType
        case createdAt
        case updatedAt
        case courseId = "brevetId"
        case courseName = "brevetName"
        case materialId = "materiId"
        case materialName = "materiName"
        case materialPicture = "materiPicture"
        case materialDescription = "materiDescription"
        case chapterId
        case chapterName
        case isViewed = "viewed"
        case comments = "comment"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}

class CommentModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var videoId: String?
    @objc dynamic var parentId: String?
    @objc dynamic var userId: String?
    @objc dynamic var userName: String?
    @objc dynamic var comment: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var picture: String?
    @objc dynamic var status: String?
    var childrenComments = List<ChildrenCommentModel>()
    @objc dynamic var user: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoId
        case parentId
        case userId
        case userName
        case comment
        case createdAt
        case updatedAt
        case picture
        case status
        case childrenComments
        case user = "users"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}

class ChildrenCommentModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var videoId: String?
    @objc dynamic var parentId: String?
    @objc dynamic var userId: String?
    @objc dynamic var userName: String?
    @objc dynamic var comment: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var picture: String?
    @objc dynamic var status: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
