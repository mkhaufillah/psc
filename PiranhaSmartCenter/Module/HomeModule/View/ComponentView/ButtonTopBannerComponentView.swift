//
//  ButtonTopBannerComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ButtonTopBarComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let title: String,
        backgroundColorImg: String,
        foregroundColorImg: String,
        foregroundColorText: String,
        icon: String,
        action: () -> Void
    
    init (title: String, backgroundColorImg: String, foregroundColorImg: String, foregroundColorText: String, icon: String, action: @escaping () -> Void) {
        self.title = title
        self.backgroundColorImg = backgroundColorImg
        self.foregroundColorImg = foregroundColorImg
        self.foregroundColorText = foregroundColorText
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        ZStack {
            Button(action: {
                action()
            }) {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: bounds.size.width/11, height: bounds.size.width/11, alignment: .center)
                        .padding((bounds.size.width/11)/2)
                        .foregroundColor(Color(foregroundColorImg))
                        .background(Color(backgroundColorImg))
                        .cornerRadius(12)
                    Text(title)
                        .foregroundColor(Color(foregroundColorText))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .buttonStyle(DefaultButtonStyleHelper())
        }
    }
}
