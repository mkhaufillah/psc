//
//  ExerciseQuestionViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation
import RealmSwift

class ExerciseQuestionViewModel: ObservableObject {
    @Published var dataStatusQuestion: DataStatus = .Init
    @Published var dataStatusAnswer: DataStatus = .Init
    
    @Published var dataExercise: ExamExerciseModel?
    @Published var dataQuestion = Array<QuestionModel>()
    @Published var dataAnswer = [Int: String]()
    
    @Published var answer = ""
    @Published var indexQuestionShow = -1
    
    @Published var timerDisplay = "00:00"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var counterErr = 0
    
    func initDataQuestion(idMaterial: Int, errorCallback: @escaping () -> Void = {}) {
        // Get courses from network
        self.dataStatusQuestion = .InProgressToNetwork
        
        let exerciseQuestionProvider = ExerciseQuestionProvider(idMaterial: idMaterial)
        
        exerciseQuestionProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if self.counterErr <= 3 {
                        if (error?.desc ?? "").contains(ErrorString.decodeFailedTag) {
                            self.initDataQuestion(idMaterial: idMaterial) {
                                errorCallback()
                            }
                            self.counterErr += 1
                            return
                        }
                    }
                    
                    if (error?.desc ?? "").contains(ErrorString.decodeFailedTag) {
                        errorCallback()
                        
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ExerciseString.exerciseNotReady)
                        
                        self.dataStatusQuestion = .NotInLocal
                        
                        return
                    }
                    
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    
                    self.dataStatusQuestion = .NotInLocal
                }
                if result != nil {
                    self.dataExercise = result?.data?.exercise
                    self.dataQuestion = RealmListHelper<QuestionModel>().listToArray(list: result?.data?.questions ?? List<QuestionModel>())
                    
                    self.indexQuestionShow = 0
                    
                    self.dataStatusQuestion = .InNetwork
                    
                    self.counterErr = 0
                }
            }
        })
    }
    
    func postDataAnswer(callback: @escaping () -> Void = {}) {
        if dataExercise == nil || dataQuestion.count <= 0 {
            return
        }
        
        if answer == "" {
            answer = dataAnswer[dataQuestion[indexQuestionShow].id] ?? ""
            
            if answer == "" {
                answer = dataQuestion[indexQuestionShow].answer ?? ""
            }
            
            if answer == "" {
                NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ExerciseString.pleaseChoseAnswer)
                return
            }
        }
        
        if dataAnswer[dataQuestion[indexQuestionShow].id] == answer {
            self.answer = ""
            if self.indexQuestionShow < self.dataQuestion.count - 1 {
                self.indexQuestionShow += 1
            }
            callback()
            return
        }
        
        if dataAnswer[dataQuestion[indexQuestionShow].id] == nil && dataQuestion[indexQuestionShow].answer == answer {
            dataAnswer[dataQuestion[indexQuestionShow].id] = answer
            self.answer = ""
            if self.indexQuestionShow < self.dataQuestion.count - 1 {
                self.indexQuestionShow += 1
            }
            callback()
            return
        }
        
        if dataAnswer[dataQuestion[indexQuestionShow].id] == dataQuestion[indexQuestionShow].answer && dataQuestion[indexQuestionShow].answer == answer {
            self.answer = ""
            if self.indexQuestionShow < self.dataQuestion.count - 1 {
                self.indexQuestionShow += 1
            }
            callback()
            return
        }
        
        // Get courses from network
        self.dataStatusAnswer = .InProgressToNetwork
        
        let postAnswerExerciseProvider = PostAnswerExerciseProvider()
        
        postAnswerExerciseProvider.doAction(
            request: PostAnswerQuestionRequestModel(
                resultId: "\(dataExercise?.id ?? 0)",
                questionId: "\(dataQuestion[indexQuestionShow].id)",
                answer: answer
            ),
            response: { result, error in
                DispatchQueue.main.async {
                    if error != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                        self.dataStatusAnswer = .NotInLocal
                    }
                    if result != nil {
                        self.dataAnswer[self.dataQuestion[self.indexQuestionShow].id] = self.answer
                        self.answer = ""
                        if self.indexQuestionShow < self.dataQuestion.count - 1 {
                            self.indexQuestionShow += 1
                        }
                        self.dataStatusAnswer = .InNetwork
                        callback()
                    }
                }
            }
        )
    }
    
    func finish(callback: @escaping () -> Void) {
        // Get courses from network
        self.dataStatusAnswer = .InProgressToNetwork
        
        let finishProvider = FinishExerciseExamProvider()
        
        finishProvider.doAction(
            request: FinishExamExerciseRequestModel(
                resultId: "\(dataExercise?.id ?? 0)",
                type: "exercise"
            ),
            response: { result, error in
                DispatchQueue.main.async {
                    if error != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                        self.dataStatusAnswer = .NotInLocal
                    }
                    if result != nil {
                        callback()
                        self.dataStatusAnswer = .InNetwork
                    }
                }
            }
        )
    }
}
