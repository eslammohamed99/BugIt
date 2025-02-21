//
//  LoadingView.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import SwiftUI

struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        content.overlay {
            if isLoading {
                LoadingOverlayView()
            }
        }
    }
}

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .scaleEffect(2.0)
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}


#Preview {
    LoadingOverlayView()
}
