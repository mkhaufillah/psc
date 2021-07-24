//
//  ProfileProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct ProfileProvider: ProviderGetProtocol {
    typealias Response = ProfileResponseModel
    
    func doAction(response: @escaping (ProfileResponseModel?, AppError?) -> Void) {
        SecureRequestGetProvider<ProfileResponseModel>(url: ApiUrlStatic.profile)
            .doAction() { res, err in
                response(res, err)
            }
    }
}
