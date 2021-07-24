//
//  WhatsappHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import Foundation
import SwiftUI

class WhatsappHelper {
    static func doOpen(number: String, text: String) -> AppError? {
        let url = "https://wa.me/\(number)?text=\(text)"
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                    return nil
                } else {
                    return AppError(desc: ErrorString.whatsappCannotOpened)
                }
            }
        }
        return AppError(desc: ErrorString.urlInvalid)
    }
}
