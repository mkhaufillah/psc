//
//  ChipComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import SwiftUI

struct ChipComponentView: View {
    let title: String, action: () -> Void, isLoading: Bool, isActive: Bool, leadingImg: String?, traillingImg: String?
    
    init(title: String, action: @escaping () -> Void, isLoading: Bool = false, isActive: Bool = true, leadingImg: String? = nil, traillingImg: String? = nil) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isActive = isActive
        self.leadingImg = leadingImg
        self.traillingImg = traillingImg
    }
    
    var body: some View {
        Button(action: action) {
            if isLoading == true {
                ProgressView().padding(.horizontal)
            } else {
                HStack(alignment: .center, spacing: 8) {
                    if leadingImg != nil {
                        Image(systemName: leadingImg ?? "")
                    }
                    Text(title)
                    if traillingImg != nil {
                        Image(systemName: traillingImg ?? "")
                    }
                }
            }
        }
        .buttonStyle(PrimaryChipStyleHelper(disabled: isLoading, active: isActive))
    }
}

private struct PrimaryChipStyleHelper: ButtonStyle {
    let disabled: Bool
    let active: Bool
    
    init(disabled: Bool, active: Bool) {
        self.disabled = disabled
        self.active = active
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(active ? Color("BackgroundColor") : Color.accentColor)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .stroke(
                    !disabled ?
                        LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [Color("ForegroundLayer2Color"), Color("ForegroundLayer2Color")]), startPoint: .leading, endPoint: .trailing),
                    lineWidth: 3
                )
                .background(
                    !disabled ?
                        active ?
                        LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [Color("ForegroundLayer2Color"), Color("ForegroundLayer2Color")]), startPoint: .leading, endPoint: .trailing)
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
