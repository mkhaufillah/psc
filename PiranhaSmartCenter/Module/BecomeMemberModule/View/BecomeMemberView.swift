//
//  BecomeMemberView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct BecomeMemberView: View {
    @Binding var isRootActive: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @StateObject var becomeMemberViewModel = BecomeMemberViewModel()
    
    private let bounds = UIScreen.main.bounds
    
    init(isRootActive: Binding<Bool>) {
        self._isRootActive = isRootActive
    }
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: InfoPaymentView(isRootActive: $isRootActive)
                        .onAppear {
                            becomeMemberViewModel.initListBank()
                        }
                        .environmentObject(becomeMemberViewModel),
                    isActive: $becomeMemberViewModel.infoPaymentPageIsActive
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
                    .disabled(becomeMemberViewModel.isPrecessingPayment)
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            Spacer()
                            Text(BecomeMemberString.welcome)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.bottom, -8)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Text(BecomeMemberString.becomeMemberDesc)
                                .padding(.horizontal)
                                .lineLimit(5)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Image("BecomeMemberImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bounds.size.width / 1.3 - 32)
                                .padding(.horizontal)
                            Spacer()
                            ButtonComponentView.primaryButton(
                                title: BecomeMemberString.subscribe, action: {
                                    /// App store policy
                                    // becomeMemberViewModel.infoPaymentPageIsActive = true
                                    becomeMemberViewModel.inAppPurchase() {
                                        rootViewModel.initDataUserFromNetwork()
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                },
                                isLoading: (!becomeMemberViewModel.isCompletedFetchProduct || becomeMemberViewModel.isPrecessingPayment) && !becomeMemberViewModel.isErrorFetch,
                                isDisabled: !becomeMemberViewModel.isCompletedFetchProduct || becomeMemberViewModel.isPrecessingPayment || becomeMemberViewModel.isErrorFetch
                            )
                            Spacer()
                            
                        }
                        .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
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
                if becomeMemberViewModel.isPrecessingPayment {
                    return
                }
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
