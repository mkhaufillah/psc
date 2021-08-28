//
//  AdsModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 28/08/21.
//

import RealmSwift

struct AdsResponseModel: Codable, ResponseProtocol {
    typealias DataModel = AdsDataModel?
    let version: String?
    let statusCode: Int?
    let data: AdsDataModel?
}

class AdsDataModel: Object, Codable {
    var data = List<AdsModel>()
    @objc dynamic var pagination: PaginationModel?
}

class AdsModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var photo: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

