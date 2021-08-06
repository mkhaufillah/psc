//
//  ErrorComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import SwiftUI

struct ErrorComponentView {
    static func simple(reload: @escaping () -> Void) -> some View {
        HStack {
            Text(ErrorString.failedToLoadData + ",")
            Button(action: {
                reload()
            }) {
                HStack {
                    Text(ErrorString.retry)
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
