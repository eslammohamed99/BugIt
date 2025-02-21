//
//  BaseCoordinatorProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 04/12/2024.
//

import UIKit

public protocol BaseCoordinatorProtocol: AnyObject {
    var dependencies: [BaseCoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
}

// MARK: - BaseCoordinatorProtocol Childs Funs
public extension BaseCoordinatorProtocol where Self: UINavigationControllerDelegate {

    func addChild(_ child: BaseCoordinator) {
        self.dependencies.append(child)
        child.onDismiss = { [weak self, weak child] in
            self?.removeChild(child)
            self?.navigationController?.delegate = self
        }
    }

    private func removeChild(_ child: BaseCoordinator?) {
        self.dependencies.removeElementByReference(child)
    }

}
public extension Array {

    mutating func removeElementByReference(_ element: Element?) {
        if let element = element {
            removeElementByReference(element)
        }
    }

    mutating func removeElementByReference(_ element: Element) {
        let objIndex = firstIndex {
            return $0 as AnyObject === element as AnyObject
        }

        if let objIndex = objIndex {
            remove(at: objIndex)
        }
    }
    func chunkedInto(size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
          let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
          let date = Calendar.current.date(from: components)!
          let existing = acc[date] ?? []
          acc[date] = existing + [cur]
        }
        return groupedByDateComponents
      }
}
public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
