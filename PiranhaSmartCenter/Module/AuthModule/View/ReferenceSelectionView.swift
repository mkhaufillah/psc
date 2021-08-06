//
//  ReferenceSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import SwiftUI

struct ReferenceSelectionView: View {
    private let bounds = UIScreen.main.bounds
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    ButtonComponentView.textFieldFullButton(title: HelperString.instagram, action: {
                        registerViewModel.reference = ReferenceHelper.instagram
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.reference != ReferenceHelper.instagram ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.facebook, action: {
                        registerViewModel.reference = ReferenceHelper.facebook
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.reference != ReferenceHelper.facebook ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.twitter, action: {
                        registerViewModel.reference = ReferenceHelper.twitter
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.reference != ReferenceHelper.twitter ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.youtube, action: {
                        registerViewModel.reference = ReferenceHelper.youtube
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.reference != ReferenceHelper.youtube ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.others, action: {
                        registerViewModel.reference = ReferenceHelper.others
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.reference != ReferenceHelper.others ? nil : "checkmark.circle.fill", isCenter: false)
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.reference)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct ReferenceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
