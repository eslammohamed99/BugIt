//
//  BugDetailViewModelProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//
import UIKit
enum BugDetailViewModelCallbackType {
    case back
}

typealias BugDetailViewModelCallback = (BugDetailViewModelCallbackType) -> Void

protocol BugDetailViewModelProtocol: AnyObject {
    var callback: BugDetailViewModelCallback { get set }
    func viewDidLoad()
    func bindActions()
}
