//
//  NetworkClient.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation
protocol NetworkClientProviderProtocol {
    func request(_ endPoint: Endpoint) async throws -> (Data,URLResponse)
}


class NetworkClient<EndPoint: Endpoint>: NetworkClientProviderProtocol{
    func request(_ endPoint: any Endpoint) async throws -> (Data, URLResponse) {
        let session = URLSession.shared
        do {
            let request = NetworkRequestFactory.generateRequest(outOf: endPoint)
            NetworkLogger.log(request: request)
            return try await session.data(for: request)
        }catch {
            throw error
        }
    }
}
