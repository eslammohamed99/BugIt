//
//  AddSwiftUiView.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import UIKit
import SwiftUI

enum AppLanguage {
    case english
    case arabic
}

struct Language {
    static var currentLanguage: AppLanguage {
        // Logic to determine the current language
        // For example, based on user settings or system locale
        return .english // Example default
    }
}

 extension UIViewController {
    func addSubSwiftUIView<Content>(
        _ swiftUIView: Content,
        to view: UIView,
        language: AppLanguage = Language.currentLanguage,
        isPresent: Bool? = nil,
        backgroundColor: UIColor? = .clear) where Content: View {
        let direction: LayoutDirection = if language == .english {
            .leftToRight
        } else {
            .rightToLeft
        }
        let childView = UIHostingController(rootView: swiftUIView.environment(\.layoutDirection, direction))
        addChild(childView)
        if isPresent ?? false {
            childView.view.backgroundColor = .clear
            view.backgroundColor = .clear
        } else {
            childView.view.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
        childView.view.frame = view.bounds
        childView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
