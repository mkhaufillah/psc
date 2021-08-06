//
//  ResponseProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import Foundation

struct ResponseProvider<ResponseModel: Codable> {
    let isConvertToSnackCase: Bool
    
    init(isConvertToSnackCase: Bool = true) {
        self.isConvertToSnackCase = isConvertToSnackCase
    }
    
    func responseResult(data: Data?, res: URLResponse?, error: Error?) -> (ResponseModel?, AppError?) {
        // If has app error
        guard error == nil else {
            if GlobalStaticData.isDebug {
                print("[DebugError] " + error.debugDescription)
            }
            return (nil, AppError(desc: ErrorString.noDataConnection))
        }
        
        // If has data error
        guard let data = data else {
            if GlobalStaticData.isDebug {
                print("[DebugError] " + ErrorString.didNotReceiveData)
            }
            return (nil, AppError(desc: ErrorString.didNotReceiveData))
        }
        
        // Print result for debuging
        if GlobalStaticData.isDebug {
            do {
                let jsons = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                for json in (jsons ?? [:]) {
                    print("[DebugAPIResultSignIn] "  + json.key + ": \(json.value)")
                }
            } catch {
                print("[DebugError] " + ErrorString.JSONError)
            }
        }
        
        // Response error
        guard let res = res as? HTTPURLResponse, (200 ..< 299) ~= res.statusCode else {
            guard let res = res as? HTTPURLResponse else {
                return (nil, AppError(desc: ErrorString.HTTPError))
            }
            
            // Decode fail 1 result
            let (response1Object, err) = JSONHelper<Error1ResponseModel>(isConvertToSnackCase: isConvertToSnackCase).decode(data: data)
            // If server send error type 2
            if err != nil {
                // Decode fail 2 result
                let (response2Object, err) = JSONHelper<Error2ResponseModel>(isConvertToSnackCase: isConvertToSnackCase).decode(data: data)
                if err != nil {
                    return (nil, err)
                }
                
                // Send fail 2 result
                var errDesc = "[Error \(res.statusCode)] " + ErrorString.HTTPError + "\n" + (response2Object?.data.errors?.messages?[0][0] ?? "")
                
                if ((response2Object?.data.errors?.messages?[0][0].contains("Undefined variable: user")) != nil) {
                    errDesc = ErrorString.emailPasswordUnmatch
                }
                
                if GlobalStaticData.isDebug {
                    print("[DebugError] [Error \(res.statusCode)] " + ("\(String(describing: response2Object?.data.errors?.messages?[0]))"))
                }
                return (nil, AppError(desc: errDesc))
            }
            
            // Send fail 1 result
            let errDesc = "[Error \(res.statusCode)] " + ErrorString.HTTPError + "\n" + (response1Object?.data.errors?.messages?[0] ?? "")
            
            if GlobalStaticData.isDebug {
                print("[DebugError] [Error \(res.statusCode)] " + ("\(String(describing: response1Object?.data.errors?.messages))"))
            }
            return (nil, AppError(desc: errDesc))
        }
        
        // Decode success result
        let (responseObject, err) = JSONHelper<ResponseModel>(isConvertToSnackCase: isConvertToSnackCase).decode(data: data)
        if err != nil {
            return (nil, err)
        }
        
        return (responseObject, nil)
    }
}
