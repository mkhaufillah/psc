//
//  InfoPayment.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct InfoPaymentView: View {
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
                    destination: EvidenceUploadView(
                        isRootActive: $isRootActive
                    ).environmentObject(becomeMemberViewModel),
                    isActive: $becomeMemberViewModel.uploadEvidencePageIsActive
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
                            Text(BecomeMemberString.paymentMethodTitle)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical, 16)
                                .padding(.top, 16)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            if becomeMemberViewModel.dataStatusBanks == .InProgressToNetwork {
                                ProgressView().padding(.horizontal)
                            } else if becomeMemberViewModel.dataStatusBanks == .NotInLocal {
                                Text(BecomeMemberString.errorLoadBankList)
                            } else if becomeMemberViewModel.dataStatusBanks == .InNetwork {
                                
                                ForEach(
                                    becomeMemberViewModel.dataBanks,
                                    id: \.id
                                ) { bank in
                                    Button(action: {
                                        becomeMemberViewModel.selectedBank = bank
                                        becomeMemberViewModel.uploadEvidencePageIsActive = true
                                    }) {
                                        VStack {
                                            VStack(spacing: 8) {
                                                Text(bank.typeBank ?? "")
                                                    .fontWeight(.bold)
                                                Text(bank.noRekening ?? "")
                                                Text(bank.name ?? "")
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
                                    }
                                    .buttonStyle(DefaultButtonStyleHelper())
                                }
                                
                            }
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
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
