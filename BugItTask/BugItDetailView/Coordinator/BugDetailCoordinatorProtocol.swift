//
//  BugDetailCoordinatorProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//


import Foundation
import UIKit
enum BugDetailCoordinatorCallbackType {
    case back
}
typealias BugDetailCoordinatorCall = ((BugDetailCoordinatorCallbackType) -> Void)
protocol BugDetailCoordinatorUseCaseProtocol {
    var navigationController: UINavigationController { get set }
    var bugInfo: BugPresentedDataViewModel? { get }
}
protocol BugDetailCoordinatorProtocol: AnyObject {
    init(useCase: BugDetailCoordinatorUseCaseProtocol)
    func start(callback: @escaping BugDetailCoordinatorCall)
}
