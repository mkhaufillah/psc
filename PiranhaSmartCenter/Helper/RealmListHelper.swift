//
//  ListHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import RealmSwift

struct RealmListHelper<T:RealmCollectionValue> {
    func listToArray(list: List<T>) -> [T] {
        var array = [T]()
        for i in 0 ..< list.count {
            let result = list[i]
            array.append(result)
        }
        
        return array
    }
}
