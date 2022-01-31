//
//  LocationModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import RealmSwift

class LocationModel: Object, Codable, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["CodingKeys"]
    }
}
