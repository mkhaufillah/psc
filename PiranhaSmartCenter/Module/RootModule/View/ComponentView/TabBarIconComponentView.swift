//
//  TabBarIconComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct TabBarIconComponentView: View {
    let width,
        height: CGFloat,
        systemIconNameActive,
        systemIconNameInactive,
        tabName: String,
        assignedPage: PageTab
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        Button(action: {
            rootViewModel.currentTab = assignedPage
            rootViewModel.currentTab = assignedPage
        }) {
            VStack {
                Image(
                    systemName: assignedPage == rootViewModel.currentTab ?
                        systemIconNameActive : systemIconNameInactive
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
                .foregroundColor(
                    assignedPage == rootViewModel.currentTab ?
                        Color("ForegroundColor") : Color("ForegroundLayer1Color")
                )
                Text(tabName)
                    .font(.footnote)
                    .foregroundColor(
                        assignedPage == rootViewModel.currentTab ?
                            Color("ForegroundColor") : Color("ForegroundLayer1Color")
                    )
                Spacer()
            }
        }
        .buttonStyle(DefaultButtonStyleHelper())
        .padding(.horizontal, -4)
    }
}
