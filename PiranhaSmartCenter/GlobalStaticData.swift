//
//  GlobalStaticData.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import Foundation

struct GlobalStaticData {
    static let isDebug = false
    static let baseUrl = "https://piranhasmartcenter.com"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
