//
//  BugItListViewModelProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//
import Foundation


enum BugItListViewModelCallbackType {
    case back
    case gotoBugDetail(itemInfo:PresentedDataViewModel)
    case uploadBug
}

typealias BugItListViewModelCallback = (BugItListViewModelCallbackType) -> Void

protocol BugItListViewModelProtocol: AnyObject {
    var callback: BugItListViewModelCallback { get set }
    func viewDidLoad()
    func refreshData()
    func bindActions()
    func toggleLoading(_ bool: Bool)
}
