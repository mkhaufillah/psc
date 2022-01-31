//
//  RegisterViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 15/07/21.
//

import Foundation
import RealmSwift

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var gender = ""
    @Published var phone = ""
    @Published var birthdate = Date()
    @Published var address = ""
    @Published var reference = ""
    @Published var detailReference = ""
    @Published var education = ""
    @Published var picture: UIImage? = nil
    @Published var password = ""
    @Published var cPassword = ""
    @Published var note = ""
    @Published var refCodeId = 0
    @Published var refCodeDesc = ""
    @Published var isLoading = false
    @Published var genderSelectionPageIsActive = false
    @Published var referenceSelectionPageIsActive = false
    @Published var registerNextPageIsActive = false
    @Published var referenceCodePageIsActive = false
    @Published var isSuccessRegister = false
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var isShowSelectionProfilePicture = false
    
    // New fields 31 January 2022
    @Published var nik = ""
    @Published var religion = ""
    @Published var birthPlace = ""
    @Published var provinceId = 0
    @Published var cityId = 0
    @Published var districtId = 0
    @Published var villageId = 0
    @Published var provinceName = ""
    @Published var cityName = ""
    @Published var districtName = ""
    @Published var villageName = ""
    @Published var nameMother = ""
    @Published var nameFather = ""
    @Published var selectProvinceIsActive = false
    @Published var selectCityIsActive = false
    @Published var selectDistrictIsActive = false
    @Published var selectVillageIsActive = false
    
    @Published var dataStatusRefCodes: DataStatus = .Init
    @Published var dataRefCodes: [ReferenceCodeModel] = []
    let referenceCodeProvider = ReferenceCodeProvider()
    
    // New fields 31 January 2022
    @Published var dataStatusProvinces: DataStatus = .Init
    @Published var dataStatusCities: DataStatus = .Init
    @Published var dataStatusDistricts: DataStatus = .Init
    @Published var dataStatusVillages: DataStatus = .Init
    @Published var dataProvinces: [LocationModel] = []
    @Published var dataCities: [LocationModel] = []
    @Published var dataDistricts: [LocationModel] = []
    @Published var dataVillages: [LocationModel] = []
    let locationProvider = LocationProvider()
    
    var registerProvider = RegisterProvider()
    
    init() {
        initDataRefCodesFromNetwork()
        initDataProvincesFromNetwork()
    }
    
    func doRegister(postRegisterAction: @escaping () -> Void) {
        isLoading = true
        if verifyAllFieldFirstPage() && verifyAllFieldSecondPage() {
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            
            // Set Date Format
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            // Convert Date to String
            let birthdateConv = dateFormatter.string(from: birthdate)
            
            // Do action to register in server
            registerProvider.doAction(request: RegisterRequestModel(
                name: name,
                email: email,
                password: password,
                cPassword: cPassword,
                gender: gender,
                picture: (picture ?? UIImage()).jpegData(compressionQuality: 0.7) ?? Data(),
                address: address,
                birthdate: birthdateConv,
                referenceId: reference,
                detailReferenceEtc: detailReference,
                education: education,
                codeRefId: "\(refCodeId)",
                nik: nik,
                religion: religion,
                birthPlace: birthPlace,
                provinceId: provinceId,
                cityId: cityId,
                districtId: districtId,
                villageId: villageId,
                nameMother: nameMother,
                nameFather: nameFather
            ), response: { result, error in
                DispatchQueue.main.async {
                    if result != nil {
                        self.note = ""
                        postRegisterAction()
                    }
                    if error != nil {
                        self.note = error?.desc ?? ""
                    }
                    self.isLoading = false
                }
            })
        } else {
            isLoading = false
        }
    }
    
    func verifyAllFieldFirstPage() -> Bool {
        if name == "" {
            note = ErrorString.requiredName
            return false
        }
        
        if email == "" {
            note = ErrorString.requiredEmail
            return false
        }
        
        if !ValidationHelper.isValidEmail(email) {
            note = ErrorString.invalidEmailFormat
            return false
        }
        
        if reference == "" {
            note = ErrorString.requiredReference
            return false
        }
        
        if reference == ReferenceHelper.others && detailReference == "" {
            note = ErrorString.requiredDetailReference
            return false
        }
        
        if refCodeId == 0 {
            note = ErrorString.requiredRefCode
            return false
        }
        
        /// App store policy
        // if birthdate > Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date() {
        //     note = ErrorString.requiredBirthdate
        //     return false
        // }
        
        if gender == "" {
            /// App store policy
            // note = ErrorString.requiredGender
            // return false
            gender = "-"
        }
        
        if phone == "" {
            /// App store policy
            // note = ErrorString.requiredPhone
            // return false
            phone = "-"
        }
        
        if address == "" {
            /// App store policy
            // note = ErrorString.requiredAddress
            // return false
            address = "-"
        }
        
        if education == "" {
            /// App store policy
            // note = ErrorString.requiredEducation
            // return false
            education = "-"
        }
        
        note = ""
        return true
    }
    
    func verifyAllFieldSecondPage() -> Bool {
        if picture == nil {
            note = ErrorString.requiredPicture
            return false
        }
        
        if password == "" {
            note = ErrorString.requiredPassword
            return false
        }
        
        if cPassword != password {
            note = ErrorString.passwordUnmatch
            return false
        }
        
        note = ""
        return true
    }
    
    func initDataRefCodesFromNetwork() {
        // Get publications from network
        self.dataStatusRefCodes = .InProgressToNetwork
        referenceCodeProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle + RegisterString.getRefCode, subtitle: error?.desc ?? "")
                    self.dataStatusRefCodes = .NotInLocal
                }
                
                if result != nil {
                    self.dataRefCodes = RealmListHelper<ReferenceCodeModel>().listToArray(list: result?.data?.data ?? List<ReferenceCodeModel>())
                    self.dataStatusRefCodes = .InNetwork
                }
            }
        })
    }
    
    func initDataProvincesFromNetwork() {
        // Get publications from network
        self.dataStatusProvinces = .InProgressToNetwork
        locationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    self.dataStatusProvinces = .NotInLocal
                }
                
                if result != nil {
                    self.dataProvinces = RealmListHelper<LocationModel>().listToArray(list: result ?? List<LocationModel>())
                    self.dataStatusProvinces = .InNetwork
                }
            }
        }, locationType: LocationType.PROVINCE, params: "")
    }
    
    func initDataCitiesFromNetwork() {
        // Get publications from network
        self.dataStatusCities = .InProgressToNetwork
        locationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    self.dataStatusCities = .NotInLocal
                }
                
                if result != nil {
                    self.dataCities = RealmListHelper<LocationModel>().listToArray(list: result ?? List<LocationModel>())
                    self.dataStatusCities = .InNetwork
                }
            }
        }, locationType: LocationType.CITY, params: "\(self.provinceId)")
    }
    
    func initDataDistrictsFromNetwork() {
        // Get publications from network
        self.dataStatusDistricts = .InProgressToNetwork
        locationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    self.dataStatusDistricts = .NotInLocal
                }
                
                if result != nil {
                    self.dataDistricts = RealmListHelper<LocationModel>().listToArray(list: result ?? List<LocationModel>())
                    self.dataStatusDistricts = .InNetwork
                }
            }
        }, locationType: LocationType.DISTRICT, params: "\(self.cityId)")
    }
    
    func initDataVillagesFromNetwork() {
        // Get publications from network
        self.dataStatusVillages = .InProgressToNetwork
        locationProvider.doAction(response: { result, error in
            DispatchQueue.main.async {
                if error != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: error?.desc ?? "")
                    self.dataStatusVillages = .NotInLocal
                }
                
                if result != nil {
                    self.dataVillages = RealmListHelper<LocationModel>().listToArray(list: result ?? List<LocationModel>())
                    self.dataStatusVillages = .InNetwork
                }
            }
        }, locationType: LocationType.VILLAGE, params: "\(self.districtId)")
    }
    
    func resetCity() {
        self.cityId = 0
        self.cityName = ""
    }
    
    func resetDistrict() {
        self.districtId = 0
        self.districtName = ""
    }
    
    func resetVillage() {
        self.villageId = 0
        self.villageName = ""
    }
}
