//
//  ProfileView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 15/07/21.
//

import Foundation
import RealmSwift

class ProfileViewModel: ObservableObject {
    @Published var infoPageIsActive = false
    @Published var alertLogoutIsActive = false
    
    func removeDataUser() {
        do {
            // Delete data from realm
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            if GlobalStaticData.isDebug {
                print("[Realm error] Error when delete user data")
            }
        }
    }
}
