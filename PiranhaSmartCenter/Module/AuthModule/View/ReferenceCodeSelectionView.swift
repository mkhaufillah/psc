//
//  ReferenceCodeSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/09/21.
//

import SwiftUI

struct ReferenceCodeSelectionView: View {
    private let bounds = UIScreen.main.bounds
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    if (registerViewModel.dataStatusRefCodes == .InProgressToNetwork) {
                        ProgressView().frame(minWidth: 0, maxWidth: .infinity)
                    }
                    if (registerViewModel.dataStatusRefCodes == .NotInLocal) {
                        ErrorComponentView.simple() {
                            registerViewModel.initDataRefCodesFromNetwork()
                        }
                    }
                    if (registerViewModel.dataStatusRefCodes == .InNetwork) {
                        ForEach(
                            registerViewModel.dataRefCodes,
                            id: \.id
                        ) { dataRefCode in
                            ButtonComponentView.textFieldFullButton(title: "\(dataRefCode.code ?? "") | \(dataRefCode.desc ?? "")", action: {
                                registerViewModel.refCodeId = dataRefCode.id
                                registerViewModel.refCodeDesc = "\(dataRefCode.code ?? "") | \(dataRefCode.desc ?? "")"
                                presentationMode.wrappedValue.dismiss()
                            }, traillingImg: registerViewModel.refCodeId == dataRefCode.id ? "checkmark.circle.fill" : nil, isCenter: false)
                        }
                    }
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.refCode)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct ReferenceCodeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceCodeSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
