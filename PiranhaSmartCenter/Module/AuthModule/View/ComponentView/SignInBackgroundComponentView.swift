//
//  BackgroundComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 12/07/21.
//

import SwiftUI

struct SignInBackgroundComponentView<Content: View>: View {
    private let bounds = UIScreen.main.bounds
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Color("TransparentColor")
                    .frame(
                        width: bounds.size.width,
                        height: 1,
                        alignment: .center
                    )
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Image("LogoAlternativeImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: bounds.size.width / 3)
                                .padding(.vertical, bounds.size.height / 9)
                        }
                        .frame(width: bounds.size.width)
                        Spacer()
                        VStack(alignment: .leading, spacing: 0) {
                            content
                                .padding()
                                .padding(.bottom, bounds.size.height)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(24)
                    }
                    .padding(.bottom, -bounds.size.height)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(SignInString.title)
            .background(Image("BackgroundImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: bounds.size.width, height: bounds.size.height)
                            .ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
