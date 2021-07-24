//
//  JSONHelper.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 11/07/21.
//

import Foundation

struct JSONHelper<T:Codable> {
    func encode(object: T) -> (Data?, AppError?) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(object) else {
            if GlobalStaticData.isDebug {
                print("[DebugError] " + ErrorString.encodeFailed)
            }
            return (nil, AppError(desc: ErrorString.encodeFailed))
        }
        return (data, nil)
    }
    
    func decode(data: Data) -> (T?, AppError?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let object = try? decoder.decode(T.self, from: data) else {
            if GlobalStaticData.isDebug {
                print("[DebugError] " + ErrorString.decodeFailed)
            }
            return (nil, AppError(desc: ErrorString.decodeFailed))
        }
        return (object, nil)
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
