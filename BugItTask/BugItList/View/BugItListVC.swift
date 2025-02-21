//
//  BugItListVC.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import UIKit
class BugItListVC: UIViewController, BugItListViewProtocol {
    
    var viewModel: BugItListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        title = "BugList"
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel?.bindActions()
    }
}

private extension BugItListVC {
    func setupUI() {
        if let viewModel = viewModel as? BugItListViewModel {
            let swiftuiView = BugItListUI(viewModel: viewModel)
            addSubSwiftUIView(swiftuiView, to: view, backgroundColor: .white)
        }
    }
}
