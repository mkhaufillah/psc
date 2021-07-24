//
//  PopupMenuComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct PopupMenuComponentView: View {
    let widthAndHeight: CGFloat
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        HStack(spacing: 38) {
            Button(action: {
                withAnimation {
                    rootViewModel.isShowPopupMenu.toggle()
                }
                rootViewModel.openWhatsapp()
            }) {
                VStack {
                    Image(systemName: "message.fill")
                        .resizable()
                        .padding(12)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                        .foregroundColor(Color("ForegroundColor"))
                        .background(
                            RoundedRectangle(cornerRadius: widthAndHeight, style: .continuous)
                                .stroke(Color("ForegroundColor"), lineWidth: 3).background(Color("BackgroundLayer1Color"))
                        )
                        .cornerRadius(widthAndHeight)
                    VStack {
                        Text(RootString.contactMe)
                            .fontWeight(.bold)
                            .foregroundColor(Color("BackgroundLayer1Color"))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                    }
                    .background(Color("ForegroundColor"))
                    .cornerRadius(8)
                    
                }
            }
            .buttonStyle(DefaultButtonStyleHelper())
            Button(action: {
                withAnimation {
                    rootViewModel.isShowPopupMenu.toggle()
                }
                rootViewModel.becomeMemberPageIsActive = true
            }) {
                VStack {
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .resizable()
                        .padding(12)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: widthAndHeight, height: widthAndHeight)
                        .foregroundColor(Color("ForegroundColor"))
                        .background(
                            RoundedRectangle(cornerRadius: widthAndHeight, style: .continuous)
                                .stroke(Color("ForegroundColor"), lineWidth: 3).background(Color("BackgroundLayer1Color"))
                        )
                        .cornerRadius(widthAndHeight)
                    VStack {
                        Text(RootString.becameMember)
                            .fontWeight(.bold)
                            .foregroundColor(Color("BackgroundLayer1Color"))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                    }
                    .background(Color("ForegroundColor"))
                    .cornerRadius(8)
                    
                }
            }
            .buttonStyle(DefaultButtonStyleHelper())
        }
        .transition(.scale)
        .animation(.easeOut(duration: 0.2), value: rootViewModel.isShowPopupMenu)
    }
}
