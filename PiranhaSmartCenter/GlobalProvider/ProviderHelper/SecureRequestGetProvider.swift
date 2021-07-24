//
//  SecureRequestGetProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation
import RealmSwift

struct SecureRequestGetProvider<ResponseModel: Codable> {
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func doAction(response: @escaping (ResponseModel?, AppError?) -> Void) {
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
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
