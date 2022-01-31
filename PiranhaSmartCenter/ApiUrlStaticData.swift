//
//  ApiUrlStaticData.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

private struct BaseApiUrlStatic {
    static let base1 = "/api"
}

private struct VersionApiUrlStatic {
    static let version1 = "/v1"
}

struct ApiUrlStatic {
    // Auth
    static let signIn = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/login"
    static let register = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/register"
    static let profile = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/auth/info"
    
    // Course
    static let course = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/course/brevet"
    static let recapCourse = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/rekapitulasi_course"
    static let searchMaterial = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/course/materi/search"
    static func video(idVideo: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/course/video/\(idVideo)"
    }
    
    // User course
    static func chapter(idChapter: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/chapter/\(idChapter)"
    }
    static func userVideo(idVideo: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/video/\(idVideo)"
    }
    static let postComment = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/video-comments"
    static func updateComment(idComment: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/video-comments/\(idComment)"
    }
    static func deleteComment(idComment: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/course/video-comments/\(idComment)"
    }
    
    // CMS
    static let publication = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/publication"
    static let activity = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/activity"
    static let ads = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/slider"
    static let codeReference = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/code_reference"
    
    // CMS Payment
    static let listBank = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/cms/bank_list"
    
    // User Payment
    static let sendInvoice = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/send_invoice"
    
    // Exercise
    static func multipleExerciseQuestion(idMaterial: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exercise/multiple_question/\(idMaterial)"
    }
    static let postAnswerExercise = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exercise/answer_question_multiple"
    static let resultExercise = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exercise/result"
    static func getAnswerExercise(idExam: Int) -> String {
        return GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exercise/\(idExam)"
    }
    
    // Exam
    static let multipleExamQuestion = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exam/multiple_question"
    static let postAnswerExam = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exam/answer_question_multiple"
    static let resultExam = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/exam/result"
    
    // Finish Exercise & Exam
    static let finishExerciseExam = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/finish"
    
    // In app purchase
    static let inAppPurchase = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + "/user/in-app-purchase"
    
    // Location
    private static let locationPath = "/location"
    static let provinces = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + locationPath + "/province"
    static let cities = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + locationPath + "/cities?province="
    static let districts = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + locationPath + "/district?city="
    static let villages = GlobalStaticData.baseUrl + BaseApiUrlStatic.base1 + VersionApiUrlStatic.version1 + locationPath + "/village?district="
}
