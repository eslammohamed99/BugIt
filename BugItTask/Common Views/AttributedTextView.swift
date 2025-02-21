//
//  Untitled.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct AttributedTextView: UIViewRepresentable {
    @Binding var text: String
    var attributedPlaceholder: String
    var attributedText: (String) -> String
    var charactersLimit: Int = 160
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        
        // Basic setup
        textView.semanticContentAttribute = .unspecified
        textView.textAlignment = .natural
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        
        // Critical text wrapping settings
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.textContainer.widthTracksTextView = true
        textView.textContainer.heightTracksTextView = true
        textView.layoutManager.allowsNonContiguousLayout = false
        
        // Padding settings
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        textView.textContainer.lineFragmentPadding = 4
        
        // Placeholder setup
        let placeholderLabel = UILabel()
        placeholderLabel.text = attributedPlaceholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .gray
        placeholderLabel.isHidden = !text.isEmpty
        textView.addSubview(placeholderLabel)
        
        // Placeholder constraints
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: textView.textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: textView.textContainerInset.left + textView.textContainer.lineFragmentPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -(textView.textContainerInset.right + textView.textContainer.lineFragmentPadding)),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: textView.bottomAnchor, constant: -textView.textContainerInset.bottom)
        ])
        
        textView.delegate = context.coordinator
        textView.text = text.isEmpty ? "" : text
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update the placeholder visibility
        if let placeholderLabel = uiView.subviews.compactMap({ $0 as? UILabel }).first {
            placeholderLabel.isHidden = !text.isEmpty
        }
        
        // Only update text if it's different to avoid cursor position reset
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AttributedTextView
        
        init(_ textView: AttributedTextView) {
            self.parent = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Update placeholder visibility
            if let placeholderLabel = textView.subviews.compactMap({ $0 as? UILabel }).first {
                placeholderLabel.isHidden = !textView.text.isEmpty
            }
            
            // Handle consecutive newlines
            let newText = textView.text.replacingOccurrences(of: "\n\n+", with: "\n", options: .regularExpression)
            
            // Handle character limit
            if newText.count > parent.charactersLimit {
                let endIndex = newText.index(newText.startIndex, offsetBy: parent.charactersLimit)
                textView.text = String(newText[..<endIndex])
            } else {
                textView.text = newText
            }
            
            parent.text = textView.text
        }
    }
}
