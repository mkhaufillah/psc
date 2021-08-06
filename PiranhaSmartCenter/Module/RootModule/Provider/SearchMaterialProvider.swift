//
//  SearchMaterialProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct SearchMaterialProvider: ProviderGetProtocolWithOptionalData {
    typealias Response = SearchMaterialResponseModel
    typealias Data = Int
    
    var indexLocalData: Int
    var keyword: String
    var courseId: String
    var page: Int
    
    init(indexLocalData: Int = 0, keyword: String, courseId: String, page: Int) {
        self.indexLocalData = indexLocalData
        self.keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        self.courseId = courseId
        self.page = page
    }
    
    func doAction(response: @escaping (SearchMaterialResponseModel?, AppError?, Int) -> Void) {
        SecureRequestGetProvider<SearchMaterialResponseModel>(url: "\(ApiUrlStatic.searchMaterial)?materi=\(keyword)&brevet_id=\(courseId)&page=\(page)")
            .doAction() { res, err in
                response(res, err, indexLocalData)
            }
    }
}
