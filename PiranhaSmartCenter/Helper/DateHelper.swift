//
//  DateHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct DateHelper {
    static func stringToDate(s: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:s) ?? Date()
    }
    
    static func dateToString(d: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: d)
    }
    
    static func stringToRelativeDate(s: String, format: String) -> String {
        let date = stringToDate(s: s, format: format)
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
