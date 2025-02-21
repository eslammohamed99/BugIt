//
//  NetworkService.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation

public protocol HTTPClient {
    func sendRequest<T:Endpoint, P:Codable>(_ requestBuilder: T, model: P.Type) async throws -> P
}

extension HTTPClient {
    public func sendRequest<T:Endpoint, P:Codable>(_ requestBuilder: T, model: P.Type) async throws -> P {
        let client = NetworkClient<T>()
        do {
            let(data, response) = try await client.request(requestBuilder)
            do {
                return try self.handleNetworkResponse(response, data, model: P.self)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func handleNetworkResponse<T: Codable>(_ response: URLResponse, _ data: Data, model: T.Type) throws -> T {
        guard let response = response as? HTTPURLResponse else {throw Error.badRequest}
        let statusCode = response.statusCode
        print("StatusCode: \(statusCode)")
        switch response.statusCode {
        case 200...299:
            return try map(data, model: T.self)
        case 401...500:
            throw Error.authenticationError
        case 501...599:
            throw Error.badRequest
        case 600:
            throw Error.outdated
        default:
            throw Error.failed
        }
    }
    
    private func map<T: Codable>(_ data: Data, model: T.Type) throws -> T {
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonData as Any)
            let obj:T = try JSONDecoder().decode(T.self, from: data)
            return obj
        }catch let error {
            throw error
        }
    }
}

