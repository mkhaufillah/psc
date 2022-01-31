//
//  DistrictSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import SwiftUI

struct DistrictSelectionView: View {
    private let bounds = UIScreen.main.bounds
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    ForEach(
                        registerViewModel.dataDistricts,
                        id: \.id
                    ) { district in
                        ButtonComponentView.textFieldFullButton(title: district.name ?? "", action: {
                            registerViewModel.districtId = district.id
                            registerViewModel.districtName = district.name ?? ""
                            registerViewModel.initDataVillagesFromNetwork()
                            registerViewModel.resetVillage()
                            presentationMode.wrappedValue.dismiss()
                        }, traillingImg: registerViewModel.districtId != district.id ? nil : "checkmark.circle.fill", isCenter: false)
                    }
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.district)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct DistrictSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DistrictSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
