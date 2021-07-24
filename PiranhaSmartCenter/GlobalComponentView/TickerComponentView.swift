//
//  TickerComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/07/21.
//

import SwiftUI

struct TickerComponentView {
    
    private static func base(text: String, onClickClose: @escaping () -> Void, color: Color, withButtonClose: Bool) -> some View {
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text(text)
                    .foregroundColor(Color("BackgroundLayer1Color"))
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    .padding(.leading, 12)
            }
            if withButtonClose {
                Spacer()
                Button(action: onClickClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("BackgroundLayer1Color"))
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding(12)
            }
        }
        .background(color)
        .cornerRadius(12)
    }
    
    static func info(text: String, onClickClose: @escaping () -> Void = {}, withButtonClose: Bool = true) -> some View {
        return base(text: text, onClickClose: onClickClose, color: Color("ForegroundLayer2Color"), withButtonClose: withButtonClose)
    }
    
    static func warning(text: String, onClickClose: @escaping () -> Void = {}, withButtonClose: Bool  = true) -> some View {
        return base(text: text, onClickClose: onClickClose, color: Color("WarningColor"), withButtonClose: withButtonClose)
    }
    
    static func error(text: String, onClickClose: @escaping () -> Void = {}, withButtonClose: Bool = true) -> some View {
        return base(text: text, onClickClose: onClickClose, color: Color("ErrorColor"), withButtonClose: withButtonClose)
    }
    
    static func tips(text: String, onClickClose: @escaping () -> Void = {}, withButtonClose: Bool = true) -> some View {
        return base(text: text, onClickClose: onClickClose, color: Color("SuccessColor"), withButtonClose: withButtonClose)
    }
}
