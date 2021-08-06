//
//  PublicationListViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import Foundation
import RealmSwift

class PublicationListViewModel: ObservableObject {
    @Published var dataStatusPublications: DataStatus = .Init
    @Published var dataStatusPublicationsPerPage: DataStatus = .Init
    
    @Published var dataPublications = [PublicationModel]()
    
    @Published var publicationPage = 1
    @Published var isPublicationFinalPage = false
    
    func initDataPublicationsFromNetwork(isNextPage: Bool = false) {
        // Get publications from network
        if !isNextPage {
            self.publicationPage = 1
            self.dataStatusPublications = .InProgressToNetwork
        } else {
            self.dataStatusPublicationsPerPage = .InProgressToNetwork
        }
        
        let publicationProvider = PublicationProvider(page: publicationPage)
        
        publicationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    if isNextPage && ((error?.desc ?? "") == ErrorString.decodeFailed) {
                        self.dataStatusPublicationsPerPage = .InNetwork
                        self.isPublicationFinalPage = true
                    } else {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getMaterialData, subtitle: error?.desc ?? "")
                        self.dataStatusPublications = .NotInLocal
                    }
                }
                if result != nil {
                    if isNextPage {
                        let temp = RealmListHelper<PublicationModel>().listToArray(list: result?.data?.data ?? List<PublicationModel>())
                        
                        if temp.count <= 0 {
                            self.dataStatusPublicationsPerPage = .InNetwork
                            self.isPublicationFinalPage = true
                            return
                        }
                        
                        self.dataPublications = self.dataPublications + temp
                        
                        self.dataStatusPublicationsPerPage = .InNetwork
                        self.publicationPage += 1
                        self.isPublicationFinalPage = false
                    } else {
                        self.dataPublications = RealmListHelper<PublicationModel>().listToArray(list: result?.data?.data ?? List<PublicationModel>())
                        
                        self.dataStatusPublications = .InNetwork
                        self.publicationPage = 2
                        self.isPublicationFinalPage = false
                    }
                }
            }
        })
    }
}
