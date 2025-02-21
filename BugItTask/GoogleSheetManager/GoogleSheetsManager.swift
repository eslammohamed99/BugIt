//
//  GoogleSheetsManager.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

//
//  GoogleSheetsManager.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

class GoogleSheetsManager {
    private let service = GTLRSheetsService()

    init() {
       // service.apiKey = "AIzaSyBp4Dg4-ARNbEbaHOGJd1iHEL23sPO8G_U" // Use an API key instead of authentication
        authorizeService()
    }
    
//    private func setupServiceAccount() {
//            guard let path = Bundle.main.path(forResource: "bugit-task", ofType: "json"),
//                  let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
//                print("Error: Could not load service account credentials.")
//                return
//            }
//
//            do {
//                let auth = try GTMAppAuthFetcherAuthorization(authFromJSONData: jsonData)
//                service.authorizer = auth
//            } catch {
//                print("Error setting up authentication: \(error)")
//            }
//        }
    
    private func authorizeService() {
            guard let path = Bundle.main.path(forResource: "bugit-task", ofType: "json") else {
                print("Failed to load credentials.json")
                return
            }
            let authProvider = GTMAppAuthFetcherAuthorization(authState: nil)
            service.authorizer = authProvider
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
