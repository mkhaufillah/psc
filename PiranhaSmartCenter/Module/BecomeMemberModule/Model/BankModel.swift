//
//  BankModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import RealmSwift

struct BankResponseModel: Codable, ResponseProtocol {
    typealias DataModel = BankDataModel?
    let version: String?
    let statusCode: Int?
    let data: BankDataModel?
}

class BankDataModel: Object, Codable {
    var data = List<BankModel>()
}

class BankModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var typeBank: String?
    @objc dynamic var noRekening: String?
    @objc dynamic var name: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
