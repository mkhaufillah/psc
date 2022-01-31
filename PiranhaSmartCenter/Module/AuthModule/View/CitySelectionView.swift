//
//  CitySelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import SwiftUI

struct CitySelectionView: View {
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
                        registerViewModel.dataCities,
                        id: \.id
                    ) { city in
                        ButtonComponentView.textFieldFullButton(title: city.name ?? "", action: {
                            registerViewModel.cityId = city.id
                            registerViewModel.cityName = city.name ?? ""
                            registerViewModel.initDataDistrictsFromNetwork()
                            registerViewModel.resetDistrict()
                            registerViewModel.resetVillage()
                            presentationMode.wrappedValue.dismiss()
                        }, traillingImg: registerViewModel.cityId != city.id ? nil : "checkmark.circle.fill", isCenter: false)
                    }
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.city)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct CitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
