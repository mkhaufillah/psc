//
//  ExamModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct ExamResponseModel: Codable, ResponseProtocol {
    typealias DataModel = ExamDataModel?
    let version: String?
    let statusCode: Int?
    let data: ExamDataModel?
}

class ExamDataModel: Object, Codable {
    @objc dynamic var exam: ExamExerciseModel?
    var questions = List<QuestionModel>()
    
    enum CodingKeys: String, CodingKey {
        case exam
        case questions = "question"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}


