//
//  NotificationComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import NotificationBannerSwift
import SwiftUI

struct NotificationComponentView {
    static func showSuccessNotification(title: String, subtitle: String) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success, colors: BannerCustomColorsComponentView())
        banner.show()
    }
    static func showInfoNotification(title: String, subtitle: String) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .info, colors: BannerCustomColorsComponentView())
        banner.show()
    }
    static func showWarningNotification(title: String, subtitle: String) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .warning, colors: BannerCustomColorsComponentView())
        banner.show()
    }
    static func showErrorNotification(title: String, subtitle: String) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger, colors: BannerCustomColorsComponentView())
        banner.show()
    }
}
