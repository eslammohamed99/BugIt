//
//  BugDetailView.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import UIKit

class BugDetailView: UIViewController, BugDetailViewProtocol {
    var bugDetailUIView: BugDetailUIView?
    var viewModel: BugDetailViewModelProtocol?
    lazy var imagePicker: ImagePickerManager = {
        let imagePicker = ImagePickerManager()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.bindActions()
        configureNavigation()
    }
    
    private func configureNavigation() {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension BugDetailView {
    func setupUI() {
        if let viewModel = viewModel as? BugDetailViewModel {
            bugDetailUIView = BugDetailUIView(viewModel: viewModel, clickOnAction: {
                self.imagePicker.openImagePicker(parent: self)
            })
            addSubSwiftUIView(bugDetailUIView, to: view, backgroundColor: .white)
        }
    }
}

