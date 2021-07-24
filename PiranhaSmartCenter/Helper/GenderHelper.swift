//
//  GenderHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

struct GenderHelper {
    static let male = "male"
    static let female = "female"
    static let others = "others"
    
    static func getDesc(raw: String) -> String {
        return raw == male ? HelperString.male : raw == female ? HelperString.female : HelperString.others
    }
}
