//
//  VideoViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 25/07/21.
//

import Foundation
import RealmSwift

class VideoViewModel: ObservableObject {
    @Published var dataStatusUser: DataStatus = .Init
    @Published var dataStatusComments: DataStatus = .Init
    
    @Published var dataUser: UserModel? = nil
    @Published var dataComments = [CommentModel]()
    @Published var dataChildrenComments = [Int:[ChildrenCommentModel]]()
    
    @Published var comment = ""
    @Published var isPlaying = false
    @Published var showcontrols = false
    @Published var value: Float = 0
    
    @Published var parentComment = ""
    @Published var idEditedComment = 0
    @Published var idParentEditedComment = 0
    @Published var isReply = false
    @Published var isEdit = false
    
    @Published var selectedComment: CommentModel?
    
    @Published var isFirstTime = true
    
    init() {
        // Get in local user
        do {
            let realm = try Realm()
            let data = realm.objects(SignInDataModel.self)
            dataUser = data.first?.user
            
            if dataUser == nil {
                dataStatusUser = .NotInLocal
            }
            
            dataStatusUser = .InLocal
        } catch {
            if GlobalStaticData.isDebug {
                print("[Realm error] Error when read user data")
            }
            dataStatusUser = .NotInLocal
        }
    }
    
    func initDataComments(typeVideo: String, idVideo: Int) {
        let videoProvider = VideoProvider(idVideo: idVideo, typeVideo: typeVideo)
        self.dataStatusComments = .InProgressToNetwork
        videoProvider.doAction(response: { res, err in
            DispatchQueue.main.async {
                if err != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: err?.desc ?? "")
                    self.dataStatusComments = .NotInLocal
                }
                if res != nil {
                    self.dataComments = RealmListHelper<CommentModel>().listToArray(list: res?.data?.data[0].comments ?? List<CommentModel>())
                    
                    for comment in self.dataComments {
                        self.dataChildrenComments[comment.id] = RealmListHelper<ChildrenCommentModel>().listToArray(list: comment.childrenComments)
                    }
                    
                    self.dataStatusComments = .InNetwork
                }
            }
        })
    }
    
    func postMyComment(idVideo: Int, parentId: String, callback: @escaping () -> Void) {
        if !isReply {
            selectedComment = nil
        }
        if !isEdit {
            idEditedComment = 0
            idParentEditedComment = 0
        }
        
        let postCommentProvider = PostCommentProvider()
        self.dataStatusComments = .InProgressToNetwork
        postCommentProvider.doAction(
            request: PostCommentRequestModel(videoId: "\(idVideo)", parentId: parentId, comment: self.comment),
            response: { res, err in
                DispatchQueue.main.async {
                    if err != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: err?.desc ?? "")
                        self.dataStatusComments = .NotInLocal
                    }
                    if res != nil {
                        self.comment = ""
                        self.parentComment = ""
                        self.isReply = false
                        self.isEdit = false
                        
                        callback()
                        
                        self.dataStatusComments = .InNetwork
                    }
                }
            }
        )
    }
    
    func deleteMyComment(idComment: Int, callback: @escaping () -> Void) {
        let deleteCommentProvider = DeleteCommentProvider(idComment: idComment)
        self.dataStatusComments = .InProgressToNetwork
        deleteCommentProvider.doAction(
            request: DeleteCommentRequestModel(),
            response: { res, err in
                DispatchQueue.main.async {
                    if err != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: err?.desc ?? "")
                        self.dataStatusComments = .NotInLocal
                    }
                    if res != nil {
                        callback()
                        
                        self.dataStatusComments = .InNetwork
                    }
                }
            }
        )
    }
    
    func updateMyComment(idComment: Int, idVideo: Int, parentId: String, callback: @escaping () -> Void) {
        let updateCommentProvider = UpdateCommentProvider(idComment: idComment)
        self.dataStatusComments = .InProgressToNetwork
        updateCommentProvider.doAction(
            request: UpdateCommentRequestModel(videoId: "\(idVideo)", parentId: parentId, comment: self.comment),
            response: { res, err in
                DispatchQueue.main.async {
                    if err != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RootString.getUserData, subtitle: err?.desc ?? "")
                        self.dataStatusComments = .NotInLocal
                    }
                    if res != nil {
                        self.comment = ""
                        self.parentComment = ""
                        self.isReply = false
                        self.isEdit = false
                        
                        callback()
                        
                        self.dataStatusComments = .InNetwork
                    }
                }
            }
        )
    }
}
