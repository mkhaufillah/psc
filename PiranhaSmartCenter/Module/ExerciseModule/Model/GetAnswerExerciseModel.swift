//
//  GetAnswerExerciseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct GetAnswerExerciseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = GetAnswerExerciseDataModel?
    let version: String?
    let statusCode: Int?
    let data: GetAnswerExerciseDataModel?
}

class GetAnswerExerciseDataModel: Object, Codable {
    var data = List<GetAnswerExerciseModel>()
}

class GetAnswerExerciseModel: Object, Codable, Identifiable {
    @objc dynamic var id: String?
    @objc dynamic var userId: String?
    @objc dynamic var userName: String?
    @objc dynamic var questionId: String?
    @objc dynamic var question: String?
    @objc dynamic var optionA: String?
    @objc dynamic var optionB: String?
    @objc dynamic var optionC: String?
    @objc dynamic var optionD: String?
    @objc dynamic var key: String?
    @objc dynamic var answer: String?
    @objc dynamic var result: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "exam_id"
        case userId = "user_id"
        case userName = "user_name"
        case questionId = "question_id"
        case question
        case optionA
        case optionB
        case optionC
        case optionD
        case key = "kunci"
        case answer
        case result
        case updatedAt = "updated_at"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
