//
//  NotActivatedAccount.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct NotActivatedAccount: View {
    private let bounds = UIScreen.main.bounds
    
    let title: String
    let subtitle: String
    let desc: String
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    Text(title)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -8)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Text(subtitle)
                        .padding(.horizontal)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("DeniedImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: bounds.size.width / 1.3 - 32)
                        .padding(.horizontal)
                    Spacer()
                    Text(desc)
                        .padding(.horizontal)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                }
                .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
            }
        }
    }
}
