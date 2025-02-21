//
//  ApiSettings.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//



import Foundation


enum EnvironmentTypes {
    case production
    case staging
    
    var baseUrl: String {
        switch self {
        case .staging: return "https://rickandmortyapi.com/api/"
        case .production: return "https://rickandmortyapi.com/api/"
        }
    }
}

class ApiSettings {
    var currentEnvironment: EnvironmentTypes = .production
            
    var serverBaseURL: URL {
        createURL(from: currentEnvironment.baseUrl)
    }
    
    private func createURL(from string: String) -> URL {
        guard let url = URL(string: string) else {
            fatalError("Cannot create URL from string: \(string)")
        }
        return url
    }
}

class PathProvider: PathProviderProtocol {
    var environment: ApiSettings
    
    init(environmentProvider: ApiSettings) {
        self.environment = environmentProvider
    }
    
    func createURL(type: NetworkAction) -> URL? {
        appendPath(to: environment.serverBaseURL, action: type)
    }
    
    private func appendPath(to baseURL: URL, action: NetworkAction) -> URL? {
        baseURL.appendingPathComponent(action.path)
    }
}

protocol PathProviderProtocol {
    var environment: ApiSettings { get set }
    func createURL(type: NetworkAction) -> URL?
}
