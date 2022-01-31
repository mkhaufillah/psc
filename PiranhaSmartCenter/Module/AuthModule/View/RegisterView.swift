//
//  RegisterView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 15/07/21.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var registerViewModel = RegisterViewModel()
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        RegisterBackgroundComponentView() {
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    NavigationLink(destination: GenderSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.genderSelectionPageIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: ReferenceSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.referenceSelectionPageIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: RegisterNextView().environmentObject(registerViewModel), isActive: $registerViewModel.registerNextPageIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: ReferenceCodeSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.referenceCodePageIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: ProvinceSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.selectProvinceIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: CitySelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.selectCityIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: DistrictSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.selectDistrictIsActive) {
                        EmptyView()
                    }
                    NavigationLink(destination: VillageSelectionView().environmentObject(registerViewModel), isActive: $registerViewModel.selectVillageIsActive) {
                        EmptyView()
                    }
                }
                Group {
                    // Name input
                    TextFieldComponentView(text: $registerViewModel.name)
                        .primary(title: RegisterString.name, icon: "person", position: .left, type: .name, keyboardType: .default)
                    // Email input
                    TextFieldComponentView(text: $registerViewModel.email)
                        .primary(title: RegisterString.email, icon: "envelope", position: .left, type: .emailAddress, keyboardType: .emailAddress)
                    // Gender input
                    ButtonComponentView.textFieldFullButton(title: registerViewModel.gender == "" || registerViewModel.gender == "-" ? RegisterString.gender : GenderHelper.getDesc(raw: registerViewModel.gender), action: {
                        hideKeyboard()
                        registerViewModel.genderSelectionPageIsActive = true
                    }, leadingImg: "heart", traillingImg: "chevron.forward", isCenter: false)
                    // Phone input
                    TextFieldComponentView(text: $registerViewModel.phone)
                        .primary(title: RegisterString.phone, icon: "phone", position: .left, type: .telephoneNumber, keyboardType: .phonePad)
                    // Birthdate input
                    VStack {
                        DatePicker(RegisterString.birthdate, selection: $registerViewModel.birthdate, in: ...Date(), displayedComponents: .date)
                            .id(registerViewModel.birthdate)
                            .padding()
                    }
                    .background(Color("BackgroundLayer1Color"))
                    .cornerRadius(12)
                    // Address input
                    TextFieldComponentView(text: $registerViewModel.address)
                        .primary(title: RegisterString.address, icon: "map", position: .left, type: .fullStreetAddress, keyboardType: .default)
                    // References input
                    ButtonComponentView.textFieldFullButton(title: registerViewModel.reference == "" || registerViewModel.reference == "-" ? RegisterString.reference : ReferenceHelper.getDesc(raw: registerViewModel.reference), action: {
                        hideKeyboard()
                        registerViewModel.referenceSelectionPageIsActive = true
                    }, leadingImg: "info.circle", traillingImg: "chevron.forward", isCenter: false)
                        .lineLimit(1)
                    // Reference detail input
                    if (registerViewModel.reference == ReferenceHelper.others) {
                        TextFieldComponentView(text: $registerViewModel.detailReference)
                            .primary(title: RegisterString.referenceDetail, icon: "info.circle", position: .left, keyboardType: .default)
                    }
                    TextFieldComponentView(text: $registerViewModel.education)
                        .primary(title: RegisterString.education, icon: "graduationcap", position: .left, keyboardType: .default)
                    // Reference code input
                    ButtonComponentView.textFieldFullButton(title: registerViewModel.refCodeId == 0 ? RegisterString.refCode : registerViewModel.refCodeDesc, action: {
                        hideKeyboard()
                        registerViewModel.referenceCodePageIsActive = true
                    }, leadingImg: "info.circle", traillingImg: "chevron.forward", isCenter: false)
                        .lineLimit(1)
                }
                // New field 31 January 2022
                Group {
                    // NIK input
                    TextFieldComponentView(text: $registerViewModel.nik)
                        .primary(title: RegisterString.nik, icon: "person.text.rectangle", position: .left, type: .name, keyboardType: .numberPad)
                    // Religion input
                    TextFieldComponentView(text: $registerViewModel.religion)
                        .primary(title: RegisterString.religion, icon: "rectangle.and.pencil.and.ellipsis", position: .left, type: .name, keyboardType: .default)
                    // BirthPlace input
                    TextFieldComponentView(text: $registerViewModel.birthPlace)
                        .primary(title: RegisterString.birthPlace, icon: "rectangle.and.pencil.and.ellipsis", position: .left, type: .name, keyboardType: .default)
                    // province input
                    ButtonComponentView.textFieldFullButton(title: registerViewModel.provinceId == 0 || registerViewModel.provinceName == "" || registerViewModel.provinceName == "-" ? RegisterString.province : registerViewModel.provinceName, action: {
                        hideKeyboard()
                        registerViewModel.selectProvinceIsActive = true
                    }, leadingImg: "rectangle.and.pencil.and.ellipsis", traillingImg: "chevron.forward", isCenter: false)
                        .lineLimit(1)
                    // city input
                    if registerViewModel.provinceId != 0 {
                        ButtonComponentView.textFieldFullButton(title: registerViewModel.cityId == 0 || registerViewModel.cityName == "" || registerViewModel.cityName == "-" ? RegisterString.city : registerViewModel.cityName, action: {
                            hideKeyboard()
                            registerViewModel.selectCityIsActive = true
                        }, leadingImg: "rectangle.and.pencil.and.ellipsis", traillingImg: "chevron.forward", isCenter: false)
                            .lineLimit(1)
                    }
                    // district input
                    if registerViewModel.cityId != 0 {
                        ButtonComponentView.textFieldFullButton(title: registerViewModel.districtId == 0 || registerViewModel.districtName == "" ||  registerViewModel.districtName == "-" ? RegisterString.district : registerViewModel.districtName, action: {
                            hideKeyboard()
                            registerViewModel.selectDistrictIsActive = true
                        }, leadingImg: "rectangle.and.pencil.and.ellipsis", traillingImg: "chevron.forward", isCenter: false)
                            .lineLimit(1)
                    }
                    // village input
                    if registerViewModel.districtId != 0 {
                        ButtonComponentView.textFieldFullButton(title: registerViewModel.villageId == 0 || registerViewModel.villageName == "" ||  registerViewModel.villageName == "-" ? RegisterString.village : registerViewModel.villageName, action: {
                            hideKeyboard()
                            registerViewModel.selectVillageIsActive = true
                        }, leadingImg: "rectangle.and.pencil.and.ellipsis", traillingImg: "chevron.forward", isCenter: false)
                            .lineLimit(1)
                    }
                    // MotherName input
                    TextFieldComponentView(text: $registerViewModel.nameMother)
                        .primary(title: RegisterString.nameMother, icon: "rectangle.and.pencil.and.ellipsis", position: .left, type: .name, keyboardType: .default)
                    // FatherName input
                    TextFieldComponentView(text: $registerViewModel.nameFather)
                        .primary(title: RegisterString.nameFather, icon: "rectangle.and.pencil.and.ellipsis", position: .left, type: .name, keyboardType: .default)
                }
                // Note
                if registerViewModel.note != "" {
                    TickerComponentView.error(text: registerViewModel.note, onClickClose: {
                        registerViewModel.note = ""
                    })
                }
                HStack(alignment: .center, spacing: 16) {
                    // Back to login page
                    ButtonComponentView.secondaryFullButton(title: RegisterString.back, action: {
                        presentationMode.wrappedValue.dismiss()
                    }, leadingImg: "chevron.backward")
                    // Do Register
                    ButtonComponentView.primaryFullButton(title: RegisterString.next, action: {
                        hideKeyboard()
                        if registerViewModel.verifyAllFieldFirstPage() {
                            registerViewModel.registerNextPageIsActive = true
                        }
                    }, traillingImg: "chevron.forward")
                }
                .padding(.vertical, 16)
            }
        }
        .onDisappear {
            hideKeyboard()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}

#if DEBUG
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
#endif
