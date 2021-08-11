//
//  UserModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import RealmSwift

class UserModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var emailVerifiedAt: String?
    @objc dynamic var noHp: String?
    @objc dynamic var address: String?
    @objc dynamic var gender: String?
    @objc dynamic var picture: String?
    @objc dynamic var birthdate: String?
    @objc dynamic var statusAccount: String?
    @objc dynamic var role: String?
    @objc dynamic var createdAt: String?
    @objc dynamic var updatedAt: String?
    @objc dynamic var deletedAt: String?
    @objc dynamic var referenceId: String?
    @objc dynamic var education: String?
    @objc dynamic var detailReferenceEtc: String?
    @objc dynamic var pcode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case emailVerifiedAt
        case noHp
        case address
        case gender
        case picture
        case birthdate = "birthday"
        case statusAccount
        case role
        case createdAt
        case updatedAt
        case deletedAt
        case referenceId
        case education
        case detailReferenceEtc
        case pcode
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
