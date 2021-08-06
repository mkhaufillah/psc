//
//  ExerciseAnswerViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation
import RealmSwift

class ExcerciseAnswerViewModel: ObservableObject {
    @Published var dataStatusAnswer: DataStatus = .Init
    @Published var dataAnswer = Array<GetAnswerExerciseModel>()
    
    func initDataAnswer(idExam: Int) {
        // Get courses from network
        self.dataStatusAnswer = .InProgressToNetwork
        
        let getAnswerProvider = GetAnswerExerciseProvider(idExam: idExam)
        
        getAnswerProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getCoursesData, subtitle: error?.desc ?? "")
                    self.dataStatusAnswer = .NotInLocal
                }
                if result != nil {
                    self.dataAnswer = RealmListHelper<GetAnswerExerciseModel>().listToArray(list: result?.data?.data ?? List<GetAnswerExerciseModel>())
                    
                    self.dataStatusAnswer = .InNetwork
                }
            }
        })
    }
}
