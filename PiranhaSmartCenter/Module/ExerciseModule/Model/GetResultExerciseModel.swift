//
//  GetResultExerciseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct GetResultExerciseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = GetResultExerciseDataModel?
    let version: String?
    let statusCode: Int?
    let data: GetResultExerciseDataModel?
}

class GetResultExerciseDataModel: Object, Codable {
    var data = List<GetResultExerciseModel>()
    @objc dynamic var pagination: PaginationModel?
}

class GetResultExerciseModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var userId: String?
    @objc dynamic var name: String?
    @objc dynamic var titleExercise: String?
    @objc dynamic var statusExercise: String?
    @objc dynamic var totalValueExercise: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
