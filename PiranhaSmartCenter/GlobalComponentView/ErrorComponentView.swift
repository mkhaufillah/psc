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
            Text("Gagal memuat data,")
                .foregroundColor(Color("ForegroundLayer2Color"))
            Button(action: {
                reload()
            }) {
                HStack {
                    Text("Ulangi")
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
    }
}
