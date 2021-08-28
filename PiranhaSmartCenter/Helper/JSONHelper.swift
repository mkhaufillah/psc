//
//  JSONHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/07/21.
//

import Foundation

struct JSONHelper<T:Codable> {
    let isConvertToSnackCase: Bool
    
    init(isConvertToSnackCase: Bool = true) {
        self.isConvertToSnackCase = isConvertToSnackCase
    }
    
    func encode(object: T) -> (Data?, AppError?) {
        let encoder = JSONEncoder()
        if isConvertToSnackCase {
            encoder.keyEncodingStrategy = .convertToSnakeCase
        }
        do {
            let data = try encoder.encode(object)
            return (data, nil)
        } catch let jsonError as NSError {
            if GlobalStaticData.isDebug {
                print("[DebugError][encode] " + jsonError.localizedDescription)
            }
            return (nil, AppError(desc: "[ " + ErrorString.encodeFailedTag + " ] " + jsonError.localizedDescription))
        }
    }
    
    func decode(data: Data) -> (T?, AppError?) {
        do {
            let decoder = JSONDecoder()
            if isConvertToSnackCase {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            let object = try decoder.decode(T.self, from: data)
            return (object, nil)
        } catch let jsonError as NSError {
            if GlobalStaticData.isDebug {
                print("[DebugError][decode] " + jsonError.localizedDescription)
            }
            return (nil, AppError(desc: "[ " + ErrorString.decodeFailedTag + " ] " + jsonError.localizedDescription))
        }
    }
    
    func toDictionary(data: Data) -> ([String : Any]?, AppError?) {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            return (dictionary, nil)
        } catch {
            return (nil, AppError(desc: "[DebugError] " + ErrorString.JSONError))
        }
    }
    
    func stringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
