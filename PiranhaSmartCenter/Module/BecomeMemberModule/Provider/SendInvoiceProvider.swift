//
//  SendInvoiceProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation
import RealmSwift

struct SendInvoiceProvider: ProviderPostProtocol {
    typealias Request = SendInvoiceRequestModel
    typealias Response = SendInvoiceResponseModel
    
    func doAction(request: SendInvoiceRequestModel, response: @escaping (SendInvoiceResponseModel?, AppError?) -> Void) {
        // Define URL
        guard let url = URL(string: ApiUrlStatic.sendInvoice) else {
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
        
        // Get token
        var token = ""
        do {
            let realm = try Realm()
            let data = realm.objects(SignInDataModel.self)
            token = data.first?.token ?? ""
        } catch {
            if GlobalStaticData.isDebug {
                print("[Realm error] Error when read token data")
            }
        }
        
        // Create the url request
        let req = MultipartFormDataRequestHelper(url: url, token: token)
        req.addTextField(named: "bank_id", value: request.bankId)
        req.addDataField(named: "attachment", data: request.attachment, mimeType: "image/jpeg")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        
        let session = URLSession(configuration: config)
        
        // Execute request
        session.dataTask(with: req.asURLRequest()) { data, res, error in
            let (responseData, errorData) = ResponseProvider<SendInvoiceResponseModel>().responseResult(data: data, res: res, error: error)
            response(responseData, errorData)
        }.resume()
    }
}
