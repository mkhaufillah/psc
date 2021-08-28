//
//  OnBoardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 28/08/21.
//

import SwiftUI

struct OnBoardComponentView: View {
    private let bounds = UIScreen.main.bounds
    let image: String
    let title: String
    let desc: String
    let action: () -> Void
    let isLast: Bool
    
    init(image: String, title: String, desc: String, isLast: Bool = false, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.desc = desc
        self.action = action
        self.isLast = isLast
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: bounds.size.width / 1.3 - 32)
                        .padding(.horizontal)
                        .padding(.top, 48 + 8)
                    Text(title)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Text(desc)
                        .foregroundColor(Color("ForegroundLayer1Color"))
                        .padding(.horizontal)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                    Spacer()
                    ButtonComponentView.primaryButton(title: isLast ? "       " + RootString.start + "       " : "       " + RootString.next + "       ", action: {
                        action()
                    })
                    
                }
                .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
            }
        }
    }
}
