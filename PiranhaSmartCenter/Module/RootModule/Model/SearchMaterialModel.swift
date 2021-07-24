//
//  SearchMaterialModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

struct SearchMaterialResponseModel: Codable, ResponseProtocol {
    typealias DataModel = SearchMaterialDataModel?
    let version: String?
    let statusCode: Int?
    let data: SearchMaterialDataModel?
}

class SearchMaterialDataModel: Object, Codable {
    var data = List<MaterialModel>()
    @objc dynamic var pagination: PaginationModel?
}
