//
//  RegisterNextView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import SwiftUI

struct RegisterNextView: View {
    private let bounds = UIScreen.main.bounds
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        RegisterBackgroundComponentView() {
            VStack(alignment: .center, spacing: 16) {
                NavigationLink(destination: SignInView(globalNote: RegisterString.successfullyregister), isActive: $registerViewModel.isSuccessRegister) {
                    EmptyView()
                }
                // Upload photo
                ButtonComponentView.bigRectangleImageButton(
                    title: RegisterString.uploadPhoto,
                    action: {
                        hideKeyboard()
                        registerViewModel.isShowSelectionProfilePicture = true
                    },
                    img: registerViewModel.picture
                )
                // Password input
                TextFieldComponentView(text: $registerViewModel.password)
                    .primarySecure(title: RegisterString.newPassword, icon: "lock", position: .left)
                    .padding(.top, 16)
                // Repeat password input
                TextFieldComponentView(text: $registerViewModel.cPassword)
                    .primarySecure(title: RegisterString.repeatNewPassword, icon: "lock", position: .left)
                    .lineLimit(1)
                // Note
                if registerViewModel.note != "" {
                    TickerComponentView.error(text: registerViewModel.note, onClickClose: {
                        registerViewModel.note = ""
                    })
                }
                HStack(alignment: .center, spacing: 16) {
                    // Back to login page
                    ButtonComponentView.secondaryFullButton(title: RegisterString.back, action: {
                        hideKeyboard()
                        presentationMode.wrappedValue.dismiss()
                    }, isDisabled: registerViewModel.isLoading, leadingImg: "chevron.backward")
                    .disabled(registerViewModel.isLoading)
                    // Do Register
                    ButtonComponentView.primaryFullButton(title: RegisterString.register, action: {
                        registerViewModel.doRegister {
                            hideKeyboard()
                            registerViewModel.isSuccessRegister = true
                        }
                    }, isLoading: registerViewModel.isLoading, isDisabled: registerViewModel.isLoading)
                    .disabled(registerViewModel.isLoading)
                }
                .padding(.vertical, 16)
            }
        }
        .sheet(isPresented: $registerViewModel.isShowPhotoLibrary) {
            ImagePickerComponentView(selectedImage: $registerViewModel.picture, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $registerViewModel.isShowCamera) {
            ImagePickerComponentView(selectedImage: $registerViewModel.picture, sourceType: .camera)
        }
        .alert(isPresented: $registerViewModel.isShowSelectionProfilePicture) {
            Alert(
                title: Text(RegisterString.uploadPhoto),
                message: Text(RegisterString.selectProfilePictureSource),
                primaryButton: Alert.Button.default(Text(RegisterString.photoLibrary)) {
                    registerViewModel.isShowSelectionProfilePicture = false
                    registerViewModel.isShowPhotoLibrary = true
                },
                secondaryButton: Alert.Button.default(Text(RegisterString.camera)) {
                    registerViewModel.isShowSelectionProfilePicture = false
                    registerViewModel.isShowCamera = true
                }
            )
        }
    }
}

#if DEBUG
struct RegisterNextView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNextView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif

