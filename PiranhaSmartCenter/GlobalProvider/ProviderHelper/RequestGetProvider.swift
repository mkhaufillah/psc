//
//  RequestGetProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import Foundation

struct RequestGetProvider<ResponseModel: Codable> {
    let url: String
    let isConvertToSnackCase: Bool
    
    init(url: String, isConvertToSnackCase: Bool = true) {
        self.url = url
        self.isConvertToSnackCase = isConvertToSnackCase
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
        
        // Create the url request
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Execute request
        URLSession.shared.dataTask(with: req) { data, res, error in
            let (responseData, errorData) = ResponseProvider<ResponseModel>().responseResult(data: data, res: res, error: error)
            response(responseData, errorData)
        }.resume()
    }
}
