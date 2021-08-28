//
//  SecureRequestPostProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation
import RealmSwift

struct SecureRequestPostProvider<RequestModel: Codable, ResponseModel: Codable> {
    let url: String
    let isConvertToSnackCase: Bool
    
    init(url: String, isConvertToSnackCase: Bool = true) {
        self.url = url
        self.isConvertToSnackCase = isConvertToSnackCase
    }
    
    func doAction(request: RequestModel, response: @escaping (ResponseModel?, AppError?) -> Void) {
        // Define URL
        guard let url = URL(string: url) else {
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
        
        // Encode Object to Data
        let (requestData, err) = JSONHelper<RequestModel>(isConvertToSnackCase: isConvertToSnackCase).encode(object: request)
        if err != nil {
            response(nil, err)
            return
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
            response(nil, AppError(desc: ErrorString.InvalidToken))
            return
        }
        
        if token == "" {
            response(nil, AppError(desc: ErrorString.InvalidToken))
            return
        }
        
        // Create the url request
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpBody = requestData
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        
        let session = URLSession(configuration: config)
        
        // Execute request
        session.dataTask(with: req) { data, res, error in
            let (responseData, errorData) = ResponseProvider<ResponseModel>().responseResult(data: data, res: res, error: error)
            response(responseData, errorData)
        }.resume()
    }
}
