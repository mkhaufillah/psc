//
//  NetworkProtocol.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

protocol RequestProtocol {
}

protocol ResponseProtocol {
    associatedtype DataModel
    var statusCode: Int? { get }
    var data: DataModel { get }
}

protocol ProviderPostProtocol {
    associatedtype Request
    associatedtype Response
    func doAction(request: Request, response: @escaping (Response?, AppError?) -> Void)
}

protocol ProviderGetProtocol {
    associatedtype Response
    func doAction(response: @escaping (Response?, AppError?) -> Void)
}

protocol ProviderPostProtocolWithOptionalData {
    associatedtype Request
    associatedtype Response
    associatedtype Data
    func doAction(request: Request, response: @escaping (Response?, AppError?, Data) -> Void)
}

protocol ProviderGetProtocolWithOptionalData {
    associatedtype Response
    associatedtype Data
    func doAction(response: @escaping (Response?, AppError?, Data) -> Void)
}
