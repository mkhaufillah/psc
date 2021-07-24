//
//  ReferenceHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

struct ReferenceHelper {
    static let instagram = "1"
    static let facebook = "2"
    static let twitter = "3"
    static let youtube = "4"
    static let others = "5"
    
    static func getDesc(raw: String) -> String {
        return raw == instagram ? HelperString.instagram
            : raw == facebook ? HelperString.facebook
            : raw == twitter ? HelperString.twitter
            : raw == youtube ? HelperString.youtube
            : HelperString.others
    }
}
