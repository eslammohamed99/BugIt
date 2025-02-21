//
//  BaseCoordinator.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//
import Foundation
import UIKit

public typealias Closure = () -> Void
public protocol TabBarVisibilityDelegate: AnyObject {
    var shouldShowTabBar: Bool { get }
}

open class BaseCoordinator: NSObject, BaseCoordinatorProtocol {
    public var dependencies: [BaseCoordinatorProtocol] = []
    public var onDismiss: Closure?
    public weak var navigationController: UINavigationController? {
        didSet {
            navigationController?.delegate = self
        }
    }

    public init(navigationController: UINavigationController? = nil) {
        super.init()
        self.navigationController = navigationController
        self.navigationController?.delegate = self
    }
    deinit {
        print("Deinit ", String(describing: self))
    }
    // Recursive function to handle onDismiss from the last child to the root, skipping the root itself
    public func handleOnDismissRecursively(skipRoot: Bool = true) {
        // First, call the recursive function on all children
        for dependency in dependencies {
            if let baseDependency = dependency as? BaseCoordinator {
                baseDependency.handleOnDismissRecursively(skipRoot: false)
            }
        }
        // Then, call onDismiss for the current instance if not skipping root
        if !skipRoot {
            onDismiss?()
        }
    }
    private func setTabBarVisibility(for viewController: UIViewController) {
        let tabBarVisibilityDelegate = viewController as? TabBarVisibilityDelegate
        let condition = tabBarVisibilityDelegate?.shouldShowTabBar ?? false
        viewController.tabBarController?.tabBar.isHidden = !condition
    }
}

// MARK: - UINavigationControllerDelegate
extension BaseCoordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard (navigationController.topViewController?.transitionCoordinator) != nil else {
            setTabBarVisibility(for: viewController)
            return
        }
        navigationController.topViewController?.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            if context.isInteractive {
                print("Interactive swipe transition. Start.")
            } else {
                print("Back button transition. Start.")
                self?.setTabBarVisibility(for: viewController)
            }
        }, completion: { [weak self] context in
            if context.isCancelled {
                print("Interactive swipe transition. Finish. Cancelled. We are still on child screen.")
            } else if context.initiallyInteractive {
                print("Interactive swipe transition. Finish. Sucess. We are on parent screen.")
                self?.onDismiss?()
                self?.setTabBarVisibility(for: viewController)
            } else {
                print("Back button transition. Finish. Sucess. We are on parent screen.")
            }
        })

    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        setTabBarVisibility(for: viewController)
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            onDismiss?()
        }
        return nil
    }
}

// MARK: - Avoid Erros
extension BaseCoordinatorProtocol {
// swiftlint:disable computed_accessors_order
// swiftlint:disable unused_setter_value
    public var navigationController: UINavigationController? {
        set {
            // Default to avoid errors
        }
        get { return nil }
    }
}
// swiftlint:enable computed_accessors_order
// swiftlint:enable unused_setter_value
