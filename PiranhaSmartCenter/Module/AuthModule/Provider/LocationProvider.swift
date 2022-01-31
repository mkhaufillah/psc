//
//  LocationProvider.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/01/22.
//

import Foundation
import RealmSwift

struct LocationProvider: ProviderGetProtocolLocation {
    typealias Response = List<LocationModel>
    
    func doAction(response: @escaping (List<LocationModel>?, AppError?) -> Void, locationType: LocationType, params: String) {
        // Define URL
        let rawUrl = locationType == LocationType.PROVINCE ? ApiUrlStatic.provinces
        : locationType == LocationType.CITY ? ApiUrlStatic.cities
        : locationType == LocationType.DISTRICT ? ApiUrlStatic.districts
        : ApiUrlStatic.villages
        guard let url = URL(string: rawUrl + params) else {
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
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        
        let session = URLSession(configuration: config)
        
        // Execute request
        session.dataTask(with: req) { data, res, error in
            let (responseDataList, errorData) = ResponseProvider<List>().responseResult(data: data, res: res, error: error)
            response(responseDataList, errorData)
        }.resume()
    }
}
