//
//  RecapCourseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 24/07/21.
//

import RealmSwift

struct RecapCourseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = List<RecapCourseModel>
    let version: String?
    let statusCode: Int?
    var data = List<RecapCourseModel>()
}

class RecapCourseModel: Object, Codable, Identifiable {
    @objc dynamic var courseName: String?
    @objc dynamic var totalMaterial: String?
    @objc dynamic var totalChapter: String?
    @objc dynamic var totalVideo: String?
    
    enum CodingKeys: String, CodingKey {
        case courseName = "brevetName"
        case totalMaterial = "totalMateri"
        case totalChapter
        case totalVideo
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
