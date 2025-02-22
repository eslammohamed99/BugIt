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
    

    private func setupOAuth() {
        guard let issuer = URL(string: "https://accounts.google.com/o/oauth2/auth"),
              let redirectURI = URL(string: "com.googleusercontent.apps.109775075695635212252:/oauth2redirect") else {
            print("Error setting up OAuth")
            return
        }

        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
            guard let config = configuration else {
                print("Error discovering OAuth configuration: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let request = OIDAuthorizationRequest(
                configuration: config,
                clientId: "109775075695635212252",
                scopes: ["https://www.googleapis.com/auth/spreadsheets"],
                redirectURL: redirectURI,
                responseType: OIDResponseTypeCode,
                additionalParameters: nil
            )

            if let presentingVC = UIApplication.shared.windows.first?.rootViewController {
                OIDAuthorizationService.present(request, presenting: presentingVC) { authResponse, error in
                    if let error = error {
                        print("OAuth Authorization error: \(error.localizedDescription)")
                        return
                    }

                    if let authResponse = authResponse {
                        self.currentAuthorization = AuthSession(authState: OIDAuthState(authorizationResponse: authResponse)) 
                        self.service.authorizer = self.currentAuthorization
                    }
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
