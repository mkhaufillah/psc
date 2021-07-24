//
//  SignInViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 10/07/21.
//

import Foundation
import RealmSwift

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var result: SignInResponseModel? = nil
    @Published var note = ""
    @Published var isLoading = false
    @Published var registerPageIsActive = false
    @Published var globalNote = ""
    
    var signInProvider = SignInProvider()
    
    func doLogin(postLoginAction: @escaping () -> Void) {
        // Set state to loading first
        isLoading = true
        
        if email == "" {
            note = ErrorString.requiredEmail
            isLoading = false
            return
        }
        
        if !ValidationHelper.isValidEmail(email) {
            note = ErrorString.invalidEmailFormat
            isLoading = false
            return
        }
        
        if self.password == "" {
            note = ErrorString.requiredPassword
            isLoading = false
            return
        }
        
        note = ""
        
        // Send to provider
        signInProvider.doAction(request: SignInRequestModel(email: email, password: password)) { result, error in
            DispatchQueue.main.async {
                if result != nil {
                    self.result = result
                    self.note = ""
                    
                    do {
                        // Save into local data with realm
                        let realm = try Realm()
                        try realm.write {
                            // Delete data first
                            realm.deleteAll()
                            if result != nil {
                                if result!.data != nil {
                                    realm.add(result!.data!)
                                }
                            }
                        }
                        
                        if GlobalStaticData.isDebug {
                            print("[Realm data result] ===========")
                            print(realm.objects(SignInDataModel.self))
                            print("===============================")
                        }
                        
                        postLoginAction()
                    } catch {
                        self.note = ErrorString.failAddLocalUserData + "\n" + ErrorString.failDeleteLocalUserData
                    }
                }
                if error != nil {
                    self.note = error?.desc ?? ""
                }
                self.isLoading = false
            }
        }
    }
}
