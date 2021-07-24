//
//  PublicationModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

struct PublicationResponseModel: Codable, ResponseProtocol {
    typealias DataModel = PublicationDataModel?
    let version: String?
    let statusCode: Int?
    let data: PublicationDataModel?
}

class PublicationDataModel: Object, Codable {
    var data = List<PublicationModel>()
    @objc dynamic var pagination: PaginationModel?
}

class PublicationModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    @objc dynamic var date: String?
    @objc dynamic var photo: String?
    @objc dynamic var desc: String?
    @objc dynamic var decodeDescription: String?
    @objc dynamic var publicationType: String?
    @objc dynamic var priceType: String?
    @objc dynamic var attachment: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case photo
        case desc = "description"
        case decodeDescription
        case publicationType
        case priceType
        case attachment
        case createdAt
        case updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
