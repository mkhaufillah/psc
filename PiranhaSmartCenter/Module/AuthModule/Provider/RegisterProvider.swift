//
//  RegisterProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 17/07/21.
//

import Foundation

struct RegisterProvider: ProviderPostProtocol {
    typealias Request = RegisterRequestModel
    typealias Response = RegisterResponseModel
    
    func doAction(request: RegisterRequestModel, response: @escaping (RegisterResponseModel?, AppError?) -> Void) {
        // Define URL
        guard let url = URL(string: ApiUrlStatic.register) else {
            response(nil, AppError(desc: ErrorString.urlInvalid))
            if GlobalStaticData.isDebug {
                print("[DebugError] " + ErrorString.urlInvalid)
            }
            return
        }
        
        // Print URL for debuging
        if GlobalStaticData.isDebug {
            print("[DebugURL] " + "\(url)")
        }
        
        // Create the url request
        let req = MultipartFormDataRequestHelper(url: url)
        req.addTextField(named: "name", value: request.name)
        req.addTextField(named: "email", value: request.email)
        req.addTextField(named: "password", value: request.password)
        req.addTextField(named: "c_password", value: request.cPassword)
        req.addTextField(named: "gender", value: request.gender)
        req.addDataField(named: "picture", data: request.picture, mimeType: "image/jpeg")
        req.addTextField(named: "address", value: request.address)
        req.addTextField(named: "birthday", value: request.birthdate)
        req.addTextField(named: "reference_id", value: request.referenceId)
        req.addTextField(named: "detail_reference_etc", value: request.detailReferenceEtc)
        req.addTextField(named: "education", value: request.education)
        req.addTextField(named: "code_ref_id", value: request.codeRefId)
        // New fields 31 January 2022
        req.addTextField(named: "nik", value: request.nik)
        req.addTextField(named: "religion", value: request.religion)
        req.addTextField(named: "birth_place", value: request.birthPlace)
        req.addTextField(named: "province_id", value: request.provinceId == 0 ? "" : "\(request.provinceId)")
        req.addTextField(named: "city_id", value: request.cityId == 0 ? "" : "\(request.cityId)")
        req.addTextField(named: "district_id", value: request.districtId == 0 ? "" : "\(request.districtId)")
        req.addTextField(named: "village_id", value: request.villageId == 0 ? "" : "\(request.villageId)")
        req.addTextField(named: "name_mother", value: request.nameMother)
        req.addTextField(named: "name_father", value: request.nameFather)
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        
        let session = URLSession(configuration: config)
        
        // Execute request
        session.dataTask(with: req.asURLRequest()) { data, res, error in
            let (responseData, errorData) = ResponseProvider<RegisterResponseModel>().responseResult(data: data, res: res, error: error)
            response(responseData, errorData)
        }.resume()
    }
}
