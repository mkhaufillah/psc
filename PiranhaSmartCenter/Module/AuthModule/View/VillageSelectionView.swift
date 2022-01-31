//
//  VillageSelectionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import SwiftUI

struct VillageSelectionView: View {
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
                        registerViewModel.dataVillages,
                        id: \.id
                    ) { village in
                        ButtonComponentView.textFieldFullButton(title: village.name ?? "", action: {
                            registerViewModel.villageId = village.id
                            registerViewModel.villageName = village.name ?? ""
                            presentationMode.wrappedValue.dismiss()
                        }, traillingImg: registerViewModel.villageId != village.id ? nil : "checkmark.circle.fill", isCenter: false)
                    }
                    Spacer()
                }.padding()
            }
        }
        .navigationTitle(RegisterString.village)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct VillageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VillageSelectionView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif

