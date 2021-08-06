//
//  ExerciseModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct ExerciseResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ExerciseDataModel?
    let version: String?
    let statusCode: Int?
    let data: ExerciseDataModel?
}

class ExerciseDataModel: Object, Codable {
    @objc dynamic var exercise: ExamExerciseModel?
    var questions = List<QuestionModel>()
    
    enum CodingKeys: String, CodingKey {
        case exercise
        case questions = "question"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
