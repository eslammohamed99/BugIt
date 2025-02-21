//
//  Untitled.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//
import SwiftUI

struct CustomNavigationBar: View {
    let title: String?
    let onBackTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTap) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 2)
                    
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 20, height: 15)
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            // Invisible spacer for balance if title exists
            if title != nil {
                Color.clear.frame(width: 40, height: 40)
            }
        }
        .frame(height: 90)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
    }
}
