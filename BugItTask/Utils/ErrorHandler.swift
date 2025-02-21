//
//  ErrorHandler.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import Foundation
public enum Error: Swift.Error {
    case connectivity
    case invalidData
    case notFoundUrl
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case unableToEncode
}

extension Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connectivity:
            return NSLocalizedString("No Connection", comment: "Connectivity")
        case .invalidData:
            return NSLocalizedString("Internal Error", comment: "Invalid Data")
        case .notFoundUrl:
            return NSLocalizedString("Internal Error", comment: "Not Found Url")
        default :
            return NSLocalizedString("Internal Error", comment: "connectionError!!")
        }
    }
}
