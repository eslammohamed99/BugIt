//
//  GoogleSheetsManager.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
import AppAuth
import GTMAppAuth

class AuthSession: NSObject, GTMFetcherAuthorizationProtocol {
    func authorizeRequest(_ request: NSMutableURLRequest?, delegate: Any, didFinish sel: Selector) {
            authState.performAction { accessToken, idToken, error in
                if let error = error {
                    print("Authorization error: \(error.localizedDescription)")
                    if let delegate = delegate as? NSObject {
                        delegate.perform(sel, with: error)
                    }
                    return
                }
                
                if let accessToken = accessToken, let request = request {
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    if let delegate = delegate as? NSObject {
                        delegate.perform(sel, with: nil)
                    }
                } else {
                    let error = NSError(domain: "AuthSession", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No access token"])
                    if let delegate = delegate as? NSObject {
                        delegate.perform(sel, with: error)
                    }
                }
            }
        }

    
    var userEmail: String?
    

    private let authState: OIDAuthState
    
    init(authState: OIDAuthState) {
        self.authState = authState
        super.init()
    }

    func stopAuthorization() {
    }
    
    func stopAuthorization(for request: URLRequest) {
        
    }
    
    func isAuthorizingRequest(_ request: URLRequest) -> Bool {
        return authState.isAuthorized
    }
    
    func isAuthorizedRequest(_ request: URLRequest) -> Bool {
        return authState.isAuthorized
    }
}

class GoogleSheetsManager {
    private let service = GTLRSheetsService()
    private let scopes = [
            "https://www.googleapis.com/auth/spreadsheets"
        ]
    private var currentAuthorization: AuthSession?

    init() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_SHEETS_API_KEY") as? String {
            service.apiKey = apiKey
        }
       // setupOAuth()
    }
    
    func authorize() async throws {
            guard let clientId = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String else {
                throw NSError(domain: "GoogleSheetsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing client ID"])
            }
            
            guard let redirectURI = URL(string: "com.googleusercontent.apps.626858478753-q236gnnbkggnb6d0ghq7ta1u4v69uggs:/oauth2redirect") else {
                throw NSError(domain: "GoogleSheetsManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid redirect URI"])
            }
            
            let issuer = URL(string: "https://accounts.google.com")!
            
            return try await withCheckedThrowingContinuation { continuation in
                OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let config = configuration else {
                        continuation.resume(throwing: NSError(domain: "GoogleSheetsManager", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to discover OAuth configuration"]))
                        return
                    }
                    
                    let request = OIDAuthorizationRequest(
                        configuration: config,
                        clientId: clientId,
                        scopes: self.scopes,
                        redirectURL: redirectURI,
                        responseType: OIDResponseTypeCode,
                        additionalParameters: nil
                    )
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let presentingVC = windowScene.windows.first?.rootViewController else {
                        continuation.resume(throwing: NSError(domain: "GoogleSheetsManager", code: -4, userInfo: [NSLocalizedDescriptionKey: "No presenting view controller"]))
                        return
                    }
                    
                    OIDAuthorizationService.present(request, presenting: presentingVC) { authResponse, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        
                        guard let authResponse = authResponse else {
                            continuation.resume(throwing: NSError(domain: "GoogleSheetsManager", code: -5, userInfo: [NSLocalizedDescriptionKey: "No auth response"]))
                            return
                        }
                        
                        let authState = OIDAuthState(authorizationResponse: authResponse)
                        let authorization = AuthSession(authState: authState)
                        self.currentAuthorization = authorization
                        self.service.authorizer = authorization
                        
                        // Save authorization to keychain
                       // AuthSession.save(authorization, toKeychainForName: "GoogleSheetsAuth")
                        
                        continuation.resume(returning: ())
                    }
                }
            }
        }
    
    func fetchData(spreadsheetId: String, range: String) async throws -> [[String]] {
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range: range)

        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let result = result as? GTLRSheets_ValueRange, let values = result.values as? [[String]] {
                    continuation.resume(returning: values)
                } else {
                    continuation.resume(throwing: NSError(domain: "GoogleSheetsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"]))
                }
            }
        }
    }
    
    func insertData(sheetId: String, range: String, values: [[Any]]) async throws {
        if currentAuthorization == nil {
                    try await authorize()
                }
        let valueRange = GTLRSheets_ValueRange()
        valueRange.values = values

        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: valueRange, spreadsheetId: sheetId, range: range)
        query.valueInputOption = "RAW"

        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
