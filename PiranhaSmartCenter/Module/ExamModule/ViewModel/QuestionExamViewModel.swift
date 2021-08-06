//
//  QuestionExamViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation
import RealmSwift

class QuestionExamViewModel: ObservableObject {
    @Published var dataStatusQuestion: DataStatus = .Init
    @Published var dataStatusAnswer: DataStatus = .Init
    
    @Published var dataExam: ExamExerciseModel?
    @Published var dataQuestion = Array<QuestionModel>()
    @Published var dataAnswer = [Int: String]()
    
    @Published var answer = ""
    @Published var indexQuestionShow = -1
    
    @Published var timerDisplay = "00:00"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var counterErr = 0
    
    func initDataQuestion(errorCallback: @escaping () -> Void = {}) {
        // Get courses from network
        self.dataStatusQuestion = .InProgressToNetwork
        
        let examQuestionProvider = ExamQuestionProvider()
        
        examQuestionProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if self.counterErr <= 3 {
                        if error?.desc == ErrorString.decodeFailed {
                            self.initDataQuestion() {
                                errorCallback()
                            }
                            self.counterErr += 1
                            return
                        }
                    }
                    
                    if error?.desc == ErrorString.decodeFailed {
                        errorCallback()
                        
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ExamString.examNotReady)
                        
                        self.dataStatusQuestion = .NotInLocal
                        
                        return
                    }
                    
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    
                    self.dataStatusQuestion = .NotInLocal
                }
                if result != nil {
                    self.dataExam = result?.data?.exam
                    self.dataQuestion = RealmListHelper<QuestionModel>().listToArray(list: result?.data?.questions ?? List<QuestionModel>())
                    
                    self.indexQuestionShow = 0
                    
                    self.dataStatusQuestion = .InNetwork
                    
                    self.counterErr = 0
                }
            }
        })
    }
    
    func postDataAnswer(callback: @escaping () -> Void = {}) {
        if dataExam == nil || dataQuestion.count <= 0 {
            return
        }
        
        if answer == "" {
            answer = dataAnswer[dataQuestion[indexQuestionShow].id] ?? ""
            
            if answer == "" {
                answer = dataQuestion[indexQuestionShow].answer ?? ""
            }
            
            if answer == "" {
                NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ExamString.pleaseChoseAnswer)
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
        
        let postAnswerExamProvider = PostAnswerExamProvider()
        
        postAnswerExamProvider.doAction(
            request: PostAnswerQuestionRequestModel(
                resultId: "\(dataExam?.id ?? 0)",
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
                resultId: "\(dataExam?.id ?? 0)",
                type: "exam_multiple"
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
