//
//  BugItListCoordinatorProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
enum BugItListCoordinatorCallbackType {
    case back
}
typealias BugItListCoordinatorCall = ((BugItListCoordinatorCallbackType) -> Void)
protocol BugItListCoordinatorUseCaseProtocol {
    var window: UIWindow { get set }
}
protocol BugItListCoordinatorProtocol: AnyObject {
    init(useCase: BugItListCoordinatorUseCaseProtocol)
    func start()
}
