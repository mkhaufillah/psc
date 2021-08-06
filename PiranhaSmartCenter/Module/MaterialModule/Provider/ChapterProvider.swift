//
//  ChapterProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 24/07/21.
//

import Foundation

struct ChapterProvider: ProviderGetProtocol {
    typealias Response = ChapterResponseModel
    
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func doAction(response: @escaping (ChapterResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<ChapterResponseModel>(url: "\(ApiUrlStatic.chapter(idChapter: id))")
            .doAction() { res, err in
                response(res, err)
            }
    }
}
