//
//  EvidenceUploadView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct EvidenceUploadView: View {
    @Binding var isRootActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var becomeMemberViewModel: BecomeMemberViewModel
    
    private let bounds = UIScreen.main.bounds
    
    init(isRootActive: Binding<Bool>) {
        self._isRootActive = isRootActive
    }
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ConfirmationPaymentView(
                        isRootActive: $isRootActive
                    ).environmentObject(becomeMemberViewModel),
                    isActive: $becomeMemberViewModel.confirmationPageIsActive
                ) {
                    EmptyView()
                }
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundAccentColor"), Color("BackgroundAccent2Color")]), startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    Color("TransparentColor")
                        .frame(
                            width: bounds.size.width,
                            height: 1,
                            alignment: .center
                        )
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text(BecomeMemberString.title)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(DefaultButtonStyleHelper())
                    .padding()
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            Text(BecomeMemberString.evidenceTitle)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top, 32)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            VStack {
                                VStack(spacing: 8) {
                                    Text(becomeMemberViewModel.selectedBank?.typeBank ?? "")
                                        .fontWeight(.bold)
                                    Text(becomeMemberViewModel.selectedBank?.noRekening ?? "")
                                    Text(becomeMemberViewModel.selectedBank?.name ?? "")
                                }
                                .padding(16)
                            }
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                                .stroke(
                                    Color("ForegroundLayer2Color"),
                                    lineWidth: 3
                                )
                                .background(Color("BackgroundColor"))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(BecomeMemberString.transferInfo)
                                .padding(.horizontal)
                                .lineLimit(5)
                                .multilineTextAlignment(.center)
                            Spacer()
                            // Upload photo
                            ButtonComponentView.bigSquarePotraitImageButton(
                                title: BecomeMemberString.uploadEvidence,
                                action: {
                                    becomeMemberViewModel.isShowSelectionEvidencePicture = true
                                },
                                img: becomeMemberViewModel.evidencePicture
                            )
                            ButtonComponentView.primaryButton(title: BecomeMemberString.next, action: {
                                if becomeMemberViewModel.evidencePicture == nil {
                                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: BecomeMemberString.requiredEvidence)
                                    return
                                }
                                becomeMemberViewModel.confirmationPageIsActive = true
                            })
                        }
                        .frame(minWidth: bounds.size.width)
                        .padding(.bottom, bounds.size.height)
                    }
                    .background(Color("BackgroundColor"))
                    .cornerRadius(24)
                    .padding(.bottom, -bounds.size.height)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $becomeMemberViewModel.isShowPhotoLibrary) {
            ImagePickerComponentView(selectedImage: $becomeMemberViewModel.evidencePicture, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $becomeMemberViewModel.isShowCamera) {
            ImagePickerComponentView(selectedImage: $becomeMemberViewModel.evidencePicture, sourceType: .camera)
        }
        .alert(isPresented: $becomeMemberViewModel.isShowSelectionEvidencePicture) {
            Alert(
                title: Text(RegisterString.uploadPhoto),
                message: Text(RegisterString.selectProfilePictureSource),
                primaryButton: Alert.Button.default(Text(RegisterString.photoLibrary)) {
                    becomeMemberViewModel.isShowSelectionEvidencePicture = false
                    becomeMemberViewModel.isShowPhotoLibrary = true
                },
                secondaryButton: Alert.Button.default(Text(RegisterString.camera)) {
                    becomeMemberViewModel.isShowSelectionEvidencePicture = false
                    becomeMemberViewModel.isShowCamera = true
                }
            )
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
