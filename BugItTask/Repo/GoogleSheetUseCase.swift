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
    func insertBugInfo() async throws -> Bool
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
    func insertBugInfo() async throws -> Bool {
        let data: [[Any]] = [["Bug Report new",
                              "https://firebasestorage.googleapis.com:443/v0/b/eslamtask.appspot.com/o/bug-images%2FADF34F8D-8DA0-4E58-B844-61083BDBEB27.jpg?alt=media&token=62c0d16f-f921-4817-9975-5a7ae411b04c",
                              "description new new ",
                              "02/04/2026"]]
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
