//
//  VideoProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 26/07/21.
//

import Foundation
import RealmSwift

struct VideoProvider: ProviderGetProtocol {
    typealias Response = VideoResponseModel
    
    var typeVideo: String
    var idVideo: Int
    
    init(idVideo: Int, typeVideo: String) {
        self.idVideo = idVideo
        self.typeVideo = typeVideo
    }
    
    func doAction(response: @escaping (VideoResponseModel?, AppError?) -> Void) {
        // Get token
        var statusAccount = ""
        do {
            let realm = try Realm()
            let data = realm.objects(SignInDataModel.self)
            statusAccount = data.first?.user?.statusAccount ?? "unverified"
        } catch {
            if GlobalStaticData.isDebug {
                print("[Realm error] Error when read token data")
            }
        }
        
        SecureRequestGetProvider<VideoResponseModel>(url: "\(typeVideo == "premium" || statusAccount == "verified" ? ApiUrlStatic.userVideo(idVideo: idVideo) : ApiUrlStatic.video(idVideo: idVideo))")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
