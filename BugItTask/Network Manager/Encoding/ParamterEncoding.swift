//
//  ParamterEncoding.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation
public enum ParameterEncoding {
    case url
    case queryString
    case httpBody
    case json
}

public protocol ParameterEncodingProtocol {
    func encode(urlRequest: inout URLRequest, with parameters: NetworkHTTPParameters) throws
}

public extension ParameterEncoding {

    func encode(
        urlRequest: inout URLRequest,
        bodyParameters: NetworkHTTPParameters?,
        urlParameters: NetworkHTTPParameters?
    ) throws {
        do {
            switch self {
            case .url:
                guard let urlParameters = urlParameters else { return }
                try DataParameterUrlEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .json:
                guard let bodyParameters = bodyParameters, !bodyParameters.isEmpty else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .queryString:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .httpBody:
                guard let bodyParameters = bodyParameters else { return }
                try DataParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

/// A struct which is used in encoding url parameters into encoded query.
public struct URLParameterEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: NetworkHTTPParameters) throws {
        guard let url = urlRequest.url else { throw Error.notFoundUrl }
        guard var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false),
             !parameters.isEmpty else { return }
        urlComponents.setQueryItems(with: parameters)
        urlRequest.url = urlComponents.url
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
}

/// A struct which is used in encoding body parameters to json data
public struct JSONParameterEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: NetworkHTTPParameters) throws {
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: serializedParameters(parameters),
                options: .prettyPrinted
            )
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw Error.unableToEncode
        }
    }
}

/// A struct which is used in encoding body parameters to data utf8
public struct DataParameterEncoder: ParameterEncodingProtocol {
    public  func encode(urlRequest: inout URLRequest, with parameters: NetworkHTTPParameters) throws {
        var urlComponents = URLComponents()
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        urlRequest.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
}

public struct DataParameterUrlEncoder: ParameterEncodingProtocol {
    public  func encode(urlRequest: inout URLRequest, with parameters: NetworkHTTPParameters) throws {
        urlRequest.httpBody = Data(urlEncoded(formDataSet: parameters).utf8)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }

    func urlEncoded(formDataSet: NetworkHTTPParameters) -> String {
        return formDataSet.map { key, value in
            return  key + "=\(value)"
        }
        .joined(separator: "&")
    }
}

func serializedParameters(_ parameters: NetworkHTTPParameters) -> [String: Any] {
    var serializedParameters: [String: Any] = [:]
    for (key, component) in parameters {
        serializedParameters[key] = component
    }

    return serializedParameters
}
