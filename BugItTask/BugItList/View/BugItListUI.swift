//
//  BugItListUI.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import SwiftUI

struct BugItListUI: View {
    @ObservedObject var viewModel: BugItListViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            BugListUIView(viewModel: viewModel)
            Button {
                self.viewModel.callback(.uploadBug)
            } label: {
                Text("Add New Bug")
                    .foregroundStyle(.white)
            }.frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(9999)
                .padding(.horizontal, 10)

        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .loadingOverlay(isLoading: viewModel.isLoading)
        .onAppear { Task { viewModel.viewDidLoad() } }
    }
}
private struct BugListUIView: View {
    @ObservedObject var viewModel: BugItListViewModel
    
    var body: some View {
        BugListRepresentableView(viewModel: viewModel) { bugInfo in
            self.viewModel.callback(.gotoBugDetail(itemInfo: bugInfo))
        }
    }
}
