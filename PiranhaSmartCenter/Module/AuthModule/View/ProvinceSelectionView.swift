//
//  ProvinceSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import SwiftUI

struct ProvinceSelectionView: View {
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
                        registerViewModel.dataProvinces,
                        id: \.id
                    ) { province in
                        ButtonComponentView.textFieldFullButton(title: province.name ?? "", action: {
                            registerViewModel.provinceId = province.id
                            registerViewModel.provinceName = province.name ?? ""
                            registerViewModel.initDataCitiesFromNetwork()
                            registerViewModel.resetCity()
                            registerViewModel.resetDistrict()
                            registerViewModel.resetVillage()
                            presentationMode.wrappedValue.dismiss()
                        }, traillingImg: registerViewModel.provinceId != province.id ? nil : "checkmark.circle.fill", isCenter: false)
                    }
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.province)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct ProvinceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
