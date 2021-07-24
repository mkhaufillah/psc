//
//  GenderSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import SwiftUI

struct GenderSelectionView: View {
    private let bounds = UIScreen.main.bounds
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    ButtonComponentView.textFieldFullButton(title: HelperString.male, action: {
                        registerViewModel.gender = GenderHelper.male
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.gender != GenderHelper.male ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.female, action: {
                        registerViewModel.gender = GenderHelper.female
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.gender != GenderHelper.female ? nil : "checkmark.circle.fill", isCenter: false)
                    ButtonComponentView.textFieldFullButton(title: HelperString.others, action: {
                        registerViewModel.gender = GenderHelper.others
                        presentationMode.wrappedValue.dismiss()
                    }, traillingImg: registerViewModel.gender != GenderHelper.others ? nil : "checkmark.circle.fill", isCenter: false)
                }.padding()
            }
        }
        .navigationTitle(RegisterString.gender)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
