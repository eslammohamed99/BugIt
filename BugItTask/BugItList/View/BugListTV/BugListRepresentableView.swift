//
//  BugListRepresentableView.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct BugListRepresentableView: UIViewRepresentable {
    var viewModel: BugItListViewModel
    var actionCallback: ((BugPresentedDataViewModel) -> Void)?
    
    func makeUIView(context: Context) -> UIView {
        let uiView = BugListTableView(
            frame: .zero,
            viewModel: viewModel
        )
        uiView.backgroundColor = .clear
        uiView.didTap = actionCallback
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

