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
    
    @Published var dataStatusRefCodes: DataStatus = .Init
    @Published var dataRefCodes: [ReferenceCodeModel] = []
    let referenceCodeProvider = ReferenceCodeProvider()
    
    var registerProvider = RegisterProvider()
    
    init() {
        initDataRefCodesFromNetwork()
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
                name: name, email: email, password: password, cPassword: cPassword, gender: gender, picture: (picture ?? UIImage()).jpegData(compressionQuality: 0.7) ?? Data(), address: address, birthdate: birthdateConv, referenceId: reference, detailReferenceEtc: detailReference, education: education, codeRefId: "\(refCodeId)"
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
}
