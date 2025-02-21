//
//  BugItemViewCell.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct BugCellView: View {
    let bugInfo: PresentedDataViewModel
    
    var body: some View {
        HStack(spacing: 15) {
                Text(bugInfo.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            Spacer()
            Text(bugInfo.bugDate)
                    .foregroundColor(.gray)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.lightGray).opacity(0.5), lineWidth: 1)
        )
    }
}
class BugCellViewItemView: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with bugInfo: PresentedDataViewModel) {
        contentConfiguration = UIHostingConfiguration {
            BugCellView(bugInfo: bugInfo)
        }
    }
}
