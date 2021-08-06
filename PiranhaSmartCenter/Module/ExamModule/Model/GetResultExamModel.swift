//
//  GetResultExamModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct GetResultExamResponseModel: Codable, ResponseProtocol {
    typealias DataModel = GetResultExamDataModel?
    let version: String?
    let statusCode: Int?
    let data: GetResultExamDataModel?
}

class GetResultExamDataModel: Object, Codable {
    var data = List<GetResultExamModel>()
}

class GetResultExamModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var userId: String?
    @objc dynamic var name: String?
    @objc dynamic var statusExamMultiple: String?
    @objc dynamic var totalValueExam: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
