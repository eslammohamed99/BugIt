//
//  CredentialsModel.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 22/02/2025.
//

import Foundation

// MARK: - Service Account Credentials
struct ServiceAccountCredentials: Codable {
    let type: String
    let projectId: String
    let privateKeyId: String
    let privateKey: String
    let clientEmail: String
    let clientId: String
    let authUri: String
    let tokenUri: String
    let authProviderX509CertUrl: String
    let clientX509CertUrl: String
    let apiKey: String
    let clientSecret: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case projectId = "project_id"
        case privateKeyId = "private_key_id"
        case privateKey = "private_key"
        case clientEmail = "client_email"
        case clientId = "client_id"
        case authUri = "auth_uri"
        case tokenUri = "token_uri"
        case authProviderX509CertUrl = "auth_provider_x509_cert_url"
        case clientX509CertUrl = "client_x509_cert_url"
        case apiKey = "api_key"
        case clientSecret = "client_secret"
        case refreshToken = "refresh_token"
    }
}
