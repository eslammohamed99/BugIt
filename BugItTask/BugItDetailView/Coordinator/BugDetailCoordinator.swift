//
//  BugDetailCoordinator.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit

class BugDetailCoordinator: BaseCoordinator, BugDetailCoordinatorProtocol {

    private var callback: BugDetailCoordinatorCall?
    private var viewModel: BugDetailViewModelProtocol?
    required init(useCase: BugDetailCoordinatorUseCaseProtocol) {
        super.init(navigationController: useCase.navigationController)
        viewModel = BugDetailViewModel(displayModel: useCase.bugInfo, callback: processViewModelCallback(), useCase: GoogelSheetUseCase())
    }

    func start(callback: @escaping BugDetailCoordinatorCall) {
        self.callback = callback
        let view: BugDetailViewProtocol & UIViewController = BugDetailView()
        view.viewModel = viewModel
        navigationController?.pushViewController(view, animated: true)
    }

}

private extension BugDetailCoordinator {
    func processViewModelCallback() -> BugDetailViewModelCallback {
        return { [weak self] type in
            switch type {
            case .back:
                self?.callback?(.back)
            }
        }
    }
}
