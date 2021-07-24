//
//  ProfileView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 15/07/21.
//

import SwiftUI

struct ProfileView: View {
    private let bounds = UIScreen.main.bounds
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        RefreshableComponentView(refreshing: $rootViewModel.homeRefresh) {
            if rootViewModel.homeRefresh == false {
                Spacer()
                VStack(alignment: .center, spacing: 16) {
                    ImageProfileComponentView(url: (rootViewModel.dataUser?.picture ?? "").contains("https://") ? (rootViewModel.dataUser?.picture ?? "") : "")
                    Text(rootViewModel.dataUser?.name ?? ProfileString.loadName)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .lineLimit(1)
                    Text(rootViewModel.dataUser?.email ?? ProfileString.loadEmail)
                        .lineLimit(1)
                        .padding(.bottom)
                    HStack(alignment: .center, spacing: 16) {
                        Spacer()
                        Button(action: {
                            profileViewModel.infoPageIsActive = true
                        }) {
                            VStack {
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:32, height:32)
                                    .padding(32/2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 48, style: .continuous)
                                            .stroke(Color("ForegroundColor"), lineWidth: 3).background(Color("TransparentColor"))
                                    )
                                    .foregroundColor(Color("ForegroundColor"))
                                Text(ProfileString.info)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        Button(action: {
                            rootViewModel.becomeMemberPageIsActive = true
                        }) {
                            VStack {
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:48, height:48)
                                    .padding(48/2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 72, style: .continuous)
                                            .stroke(Color("ForegroundColor"), lineWidth: 3).background(Color("TransparentColor"))
                                    )
                                    .foregroundColor(Color("ForegroundColor"))
                                Text(ProfileString.becameMember)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        Button(action: {
                            profileViewModel.alertLogoutIsActive = true
                        }) {
                            VStack {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:32, height:32)
                                    .padding(32/2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 48, style: .continuous)
                                            .stroke(Color("ForegroundColor"), lineWidth: 3).background(Color("TransparentColor"))
                                    )
                                    .foregroundColor(Color("ForegroundColor"))
                                Text(ProfileString.logout)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        Spacer()
                    }
                }
                .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
                Spacer()
            } else {
                VStack(alignment: .center) {
                    Text(RootString.refreshingData)
                        .fontWeight(.bold)
                }
                .frame(width: bounds.size.width, height: bounds.size.height/2, alignment: .center)
            }
        }
        .sheet(isPresented: $profileViewModel.infoPageIsActive) {
            InfoView()
        }
        .alert(isPresented: $profileViewModel.alertLogoutIsActive) {
            Alert(
                title: Text(ProfileString.logoutTitle),
                message: Text(ProfileString.logoutSubtitle),
                primaryButton: Alert.Button.default(Text(ProfileString.yes)) {
                    profileViewModel.removeDataUser()
                    rootViewModel.resetAllData()
                },
                secondaryButton: Alert.Button.default(Text(ProfileString.no)) {
                    profileViewModel.alertLogoutIsActive = false
                }
            )
        }
        
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif
