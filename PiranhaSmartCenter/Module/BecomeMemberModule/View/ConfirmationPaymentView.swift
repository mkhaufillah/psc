//
//  ConfirmationPaymentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct ConfirmationPaymentView: View {
    @Binding var isRootActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var becomeMemberViewModel: BecomeMemberViewModel
    
    private let bounds = UIScreen.main.bounds
    
    @GestureState private var dragOffset = CGSize.zero
    
    init(isRootActive: Binding<Bool>) {
        self._isRootActive = isRootActive
    }
    
    var body: some View {
        ZStack {
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
                        Text(BecomeMemberString.selectedPaymentMethodTitle)
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
                        Spacer()
                        Text(BecomeMemberString.evidenceTitle)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .lineLimit(5)
                            .multilineTextAlignment(.center)
                        Image(uiImage: becomeMemberViewModel.evidencePicture ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: bounds.width - 32, alignment: .center)
                            .cornerRadius(12)
                            .background(Color("OverlayColor"))
                        ButtonComponentView.primaryButton(
                            title: BecomeMemberString.confirm,
                            action: {
                                becomeMemberViewModel.sendEvidence() {
                                    isRootActive = false
                                }
                            },
                            isLoading: becomeMemberViewModel.dataStatusEvidence == .InProgressToNetwork,
                            isDisabled: becomeMemberViewModel.dataStatusEvidence == .InProgressToNetwork
                        )
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
        .navigationViewStyle(StackNavigationViewStyle())
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
