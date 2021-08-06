//
//  ExamExerciseGlobalModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct PostAnswerQuestionRequestModel: Codable, RequestProtocol {
    var resultId: String
    var questionId: String
    var answer: String
}

struct PostAnswerQuestionResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}

struct FinishExamExerciseRequestModel: Codable, RequestProtocol {
    var resultId: String
    var type: String
}

struct FinishExamExerciseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = String?
    let version: String?
    let statusCode: Int?
    let data: String?
}

class ExamExerciseModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var userId = 0
    @objc dynamic var totalValueExam: String?
    @objc dynamic var totalValueExercise: String?
    @objc dynamic var statusExamMultiple: String?
    @objc dynamic var statusExercise: String?
    @objc dynamic var lifetimeExam: String?
    @objc dynamic var lifetimeExercise: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var titleExercise: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class QuestionModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var materiId: String?
    @objc dynamic var category: String?
    @objc dynamic var type: String?
    @objc dynamic var optionA: String?
    @objc dynamic var optionB: String?
    @objc dynamic var optionC: String?
    @objc dynamic var optionD: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var answer: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case materiId = "materi_id"
        case category
        case type
        case optionA
        case optionB
        case optionC
        case optionD
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case answer
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
