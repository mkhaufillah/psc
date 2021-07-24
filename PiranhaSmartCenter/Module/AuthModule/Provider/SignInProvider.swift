//
//  SignInProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import Foundation

struct SignInProvider: ProviderPostProtocol {
    typealias Request = SignInRequestModel
    typealias Response = SignInResponseModel
    
    func doAction(request: SignInRequestModel, response: @escaping (SignInResponseModel?, AppError?) -> Void) {
        RequestPostProvider<SignInRequestModel, SignInResponseModel>(url: ApiUrlStatic.signIn)
            .doAction(request: request) { res, err in
                response(res, err)
            }
    }
}
