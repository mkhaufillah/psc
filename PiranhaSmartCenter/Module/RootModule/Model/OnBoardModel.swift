//
//  OnBoardModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 21/08/21.
//

import RealmSwift

class OnBoardModel: Object, Codable, Identifiable {
    @objc dynamic var isFirstTime: Bool
    
    override init() {
        isFirstTime = false
    }
}
