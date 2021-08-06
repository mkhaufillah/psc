//
//  SignInView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import SwiftUI

struct SignInView: View {
    @StateObject var signInViewModel = SignInViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    let globalNote: String
    
    init(globalNote: String = "") {
        self.globalNote = globalNote
    }
    
    var body: some View {
        SignInBackgroundComponentView() {
            VStack(alignment: .center, spacing: 16) {
                NavigationLink(destination: RegisterView(), isActive: $signInViewModel.registerPageIsActive) {
                    EmptyView()
                }
                // Static note
                if signInViewModel.globalNote != "" {
                    TickerComponentView.info(text: signInViewModel.globalNote, onClickClose: {
                        signInViewModel.globalNote = ""
                    })
                }
                // Note
                if signInViewModel.note != "" {
                    TickerComponentView.error(text: signInViewModel.note, onClickClose: {
                        signInViewModel.note = ""
                    })
                }
                // Email input
                TextFieldComponentView(text: $signInViewModel.email)
                    .primary(title: SignInString.email, icon: "envelope", position: .left, type: .emailAddress, keyboardType: .emailAddress)
                // Password input
                TextFieldComponentView(text: $signInViewModel.password)
                    .primarySecure(title: SignInString.password, icon: "lock", position: .left)
                // Do Login
                ButtonComponentView.primaryFullButton(title: SignInString.signIn, action: {
                    signInViewModel.doLogin() {
                        hideKeyboard()
                        rootViewModel.resetAllData()
                        rootViewModel.dataUser = signInViewModel.result!.data!.user
                    }
                }, isLoading: signInViewModel.isLoading, isDisabled: signInViewModel.isLoading)
                .disabled(signInViewModel.isLoading)
                .padding(.top, 16)
                // Go to register page
                ButtonComponentView.secondaryFullButton(title: SignInString.register, action: {
                    signInViewModel.registerPageIsActive = true
                }, isDisabled: signInViewModel.isLoading)
                .disabled(signInViewModel.isLoading)
                .padding(.bottom, 24)
                Text(SignInString.version + " " + (GlobalStaticData.appVersion ?? ""))
                    .fontWeight(.thin)
                    .foregroundColor(Color("ForegroundLayer2Color"))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .padding(.bottom, -8)
                Text("© 2020 PT Piranha Multi Talenta")
                    .fontWeight(.thin)
                    .foregroundColor(Color("ForegroundLayer2Color"))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            signInViewModel.globalNote = globalNote
        }
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
