//
//  PaginationModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import RealmSwift

class PaginationModel: Object, Codable {
    @objc dynamic var total = 0
    @objc dynamic var count = 0
    @objc dynamic var perPage = 0
    @objc dynamic var currentPage = 0
    @objc dynamic var totalPages = 0
}
