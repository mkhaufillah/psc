//
//  HistoryExamViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation
import RealmSwift

class HistoryExamViewModel: ObservableObject {
    @Published var dataStatusHistories: DataStatus = .Init
    @Published var dataHistories = [GetResultExamModel]()
    
    func initDataHistoriesFromNetwork() {
        // Get histories from network
        self.dataStatusHistories = .InProgressToNetwork
        
        let getResultExamProvider = GetResultExamProvider()
        
        getResultExamProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if !((error?.desc ?? "").contains(ErrorString.decodeFailedTag)) {
                        NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    } else {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: ErrorString.notFoundData)
                    }
                    self.dataStatusHistories = .NotInLocal
                }
                if result != nil {
                    self.dataHistories = RealmListHelper<GetResultExamModel>().listToArray(list: result?.data?.data ?? List<GetResultExamModel>())
                    
                    self.dataStatusHistories = .InNetwork
                }
            }
        })
    }
}
