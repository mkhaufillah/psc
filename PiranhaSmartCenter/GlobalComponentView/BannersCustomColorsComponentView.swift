//
//  BannersCustomColorsComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import NotificationBannerSwift
import SwiftUI

class BannerCustomColorsComponentView: BannerColorsProtocol {
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:
            return UIColor(Color("ErrorColor"))
        case .info:
            return UIColor(Color("ForegroundLayer2Color"))
        case .customView:
            return UIColor(Color("ForegroundLayer2Color"))
        case .success:
            return UIColor(Color("SuccessColor"))
        case .warning:
            return UIColor(Color("WarningColor"))
        }
    }
}
