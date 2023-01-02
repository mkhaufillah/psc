//
//  MaterialViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 24/07/21.
//

import Foundation
import RealmSwift
import AVKit

enum ResolutionVideo {
    case p
    case p360
    case p480
}

class MaterialViewModel: ObservableObject {
    @Published var selectedChapter = 0
    @Published var dataStatusVideos = [Int: DataStatus]()
    @Published var dataVideos = [Int: [ShortVideoModel]]()
    
    @Published var selectedVideo: ShortVideoModel?
    @Published var player: AVPlayer?
    @Published var playerRes: ResolutionVideo?
    @Published var videoPageIsActive = false
    
    @Published var isOpenBecomeMemberRecomendation = false
    
    func initDataChapterFromNetwork() {
        let chapterProvider = ChapterProvider(id: selectedChapter)
        // Get user from network
        self.dataStatusVideos[selectedChapter] = .InProgressToNetwork
        chapterProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: error?.desc ?? "")
                    self.dataStatusVideos[self.selectedChapter] = .InLocal
                }
                if result != nil {
                    self.dataVideos[self.selectedChapter] = RealmListHelper<ShortVideoModel>().listToArray(list: result?.data?.data.first?.videos ?? List<ShortVideoModel>())
                    self.dataStatusVideos[self.selectedChapter] = .InNetwork
                }
            }
        })
    }
}
