//
//  NetworkRequestFactory.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation
import UIKit

final class NetworkRequestFactory {

    private static func encodeParameters(_ request: inout URLRequest, outOf endpoint: Endpoint) {
        try? endpoint.parameterEncoding.encode(
            urlRequest: &request,
            bodyParameters: endpoint.parameters,
            urlParameters: endpoint.urlParameters
        )
    }

    private static func setAuthorizationType(_ request: inout URLRequest, outOf endpoint: Endpoint) {
        switch endpoint.authorizationType {
        case .none:
            break
        case .token: // add authorization token
            break
           // request.setValue("Bearer \(authTokenProvider?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
    }

    static func generateRequest(outOf endpoint: Endpoint) -> URLRequest {
        let url = endpoint.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.timeoutInterval = endpoint.timeoutInterval
        setAuthorizationType(&urlRequest, outOf: endpoint)
        encodeParameters(&urlRequest, outOf: endpoint)
        buildHeaders(&urlRequest, outOf: endpoint)
        return urlRequest
    }

    private static func buildHeaders(_ request: inout URLRequest, outOf endpoint: Endpoint) {
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        endpoint.headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
extension URLComponents {
    mutating func setQueryItems(with parameters: [String: Any]) {
        self.queryItems = parameters.map {
            URLQueryItem(
                name: $0.key,
                value: "\($0.value)")
        }
    }
}
