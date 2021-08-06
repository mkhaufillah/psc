//
//  ActivityListViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation
import RealmSwift

class ActivityListViewModel: ObservableObject {
    @Published var dataStatusActivities: DataStatus = .Init
    @Published var dataStatusActivitiesPerPage: DataStatus = .Init
    
    @Published var dataActivities = [ActivityModel]()
    
    @Published var activityPage = 1
    @Published var isActivityFinalPage = false
    
    func initDataActivitiesFromNetwork(isNextPage: Bool = false) {
        // Get activities from network
        if !isNextPage {
            self.activityPage = 1
            self.dataStatusActivities = .InProgressToNetwork
        } else {
            self.dataStatusActivitiesPerPage = .InProgressToNetwork
        }
        
        let activityProvider = ActivityProvider(page: activityPage)
        
        activityProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if isNextPage && ((error?.desc ?? "") == ErrorString.decodeFailed) {
                        self.dataStatusActivitiesPerPage = .InNetwork
                        self.isActivityFinalPage = true
                    } else {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getMaterialData, subtitle: error?.desc ?? "")
                        self.dataStatusActivities = .NotInLocal
                    }
                }
                if result != nil {
                    if isNextPage {
                        let temp = RealmListHelper<ActivityModel>().listToArray(list: result?.data?.data ?? List<ActivityModel>())
                        
                        if temp.count <= 0 {
                            self.dataStatusActivitiesPerPage = .InNetwork
                            self.isActivityFinalPage = true
                            return
                        }
                        
                        self.dataActivities = self.dataActivities + temp
                        
                        self.dataStatusActivitiesPerPage = .InNetwork
                        self.activityPage += 1
                        self.isActivityFinalPage = false
                    } else {
                        self.dataActivities = RealmListHelper<ActivityModel>().listToArray(list: result?.data?.data ?? List<ActivityModel>())
                        
                        self.dataStatusActivities = .InNetwork
                        self.activityPage = 2
                        self.isActivityFinalPage = false
                    }
                }
            }
        })
    }
}
