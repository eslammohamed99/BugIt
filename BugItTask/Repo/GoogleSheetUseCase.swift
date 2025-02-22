//
//  GoogleSheetUseCase.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
protocol GoogelSheetUseCaseProtocol {
    func getBugList() async throws -> [BugInfoModel]
    func insertBugInfo(bugName: String ,bugImage: String, bugDecription: String, bugDate: String) async throws -> Bool
}


public final class GoogelSheetUseCase: GoogelSheetUseCaseProtocol, HTTPClient {
    var pathProvider = PathProvider(environmentProvider: ApiSettings())
        let sheetManager = GoogleSheetsManager()
        let spreadsheetId = "1qjtcC21c91maCbxdmmwYxdc53FFy5yDkdT17uEojBQ4"
        let range = "Sheet1"
    func getBugList() async throws -> [BugInfoModel] {
            do {
                let data = try await sheetManager.fetchData(spreadsheetId: spreadsheetId, range: range)
                let bugReports = parseGoogleSheetData(data)
                return bugReports
            } catch {
                print("Error fetching data:", error)
                throw error
            }
    }
    func insertBugInfo(bugName: String ,bugImage: String, bugDecription: String, bugDate: String) async throws -> Bool {
        let data: [[Any]] = [["\(bugName)",
                              "\(bugImage)",
                              "\(bugDecription)",
                              "\(bugDate)"]]
            do {
                let data = try await sheetManager.insertData(sheetId: spreadsheetId, range: range, values: data)
               // let bugReports = parseGoogleSheetData(data)
                return true
            } catch {
                print("Error fetching data:", error)
                throw error
            }
    }
}
