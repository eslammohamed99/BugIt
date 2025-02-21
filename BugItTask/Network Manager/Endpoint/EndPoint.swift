//
//  EndPoint.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation

public typealias NetworkHTTPParameters = [String: AnyHashable]
public typealias ResponseElement =  Encodable&Decodable
public typealias NetworkHTTPHeaders = [String: String]

public enum AuthorizationTypes {
    case none
    case token
}

public protocol Endpoint {
    var url: URL { get }
    var headers: NetworkHTTPHeaders { get }
    var parameters: NetworkHTTPParameters? { get }
    var urlParameters: NetworkHTTPParameters? { get }
    var authorizationType: AuthorizationTypes { get }
    var method: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension Endpoint {

    var timeoutInterval: TimeInterval {
        return 60
    }
    var headers: NetworkHTTPHeaders {
        return [:]
    }
    
    var urlParameters: NetworkHTTPParameters? { return nil }
}

struct RequestEndpoint: Endpoint {
    var url: URL
    var headers: NetworkHTTPHeaders = [:]
    var parameters: NetworkHTTPParameters?
    var urlParameters: NetworkHTTPParameters?
    var authorizationType: AuthorizationTypes = .none
    var method: HTTPMethod
    var parameterEncoding: ParameterEncoding = .json
    var timeoutInterval: TimeInterval = 60
}
