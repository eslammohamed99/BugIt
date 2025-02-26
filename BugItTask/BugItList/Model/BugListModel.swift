//
//  BugListModel.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
public struct BugPresentedDataViewModel {
    static let dummy = BugPresentedDataViewModel(model: .dummy)
    public var name: String
    public var image: String
    public var bugDate: String
    public var decription: String
    
    
    init(model: BugInfoModel) {
        self.name = model.name ?? ""
        self.bugDate = model.createdAt ?? ""
        self.image = model.image ?? ""
        self.decription = model.description ?? ""
    }
}


public extension Array where Element == BugInfoModel {
    func toModels() -> [BugPresentedDataViewModel] {
        return self.map {
            BugPresentedDataViewModel(model: $0)
        }
    }
}


public struct BugInfoModel: Codable, Identifiable {
    static let dummy = BugInfoModel(
        id: 0, name: "",
        createdAt: ""
    )
    public var id: Int // Assigned dynamically based on row index
    var name: String?
    var image: String?
    var description: String?
    var createdAt: String?
}

func parseGoogleSheetData(_ values: [[String]]) -> [BugInfoModel] {
    guard let headers = values.first else { return [] } // Extract column names
    let rows = values.dropFirst() // Ignore the first row (headers)

    return rows.enumerated().map { (index, row) in
        var dataDict = [String: String]()

        for (columnIndex, header) in headers.enumerated() {
            if columnIndex < row.count {
                dataDict[header] = row[columnIndex] // Assign column value dynamically
            }
        }

        return BugInfoModel(
            id: index + 1, // Use the row index as the ID
            name: dataDict["BugTitle"],
            image: dataDict["BugImage"],
            description: dataDict["BugDescription"],
            createdAt: dataDict["createdAt"]
        )
    }
}
