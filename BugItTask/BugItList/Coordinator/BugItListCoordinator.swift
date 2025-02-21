//
//  BugItListCoordinator.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//


import UIKit

class BugItListCoordinator: BaseCoordinator, BugItListCoordinatorProtocol {
    private var callback: BugItListCoordinatorCall?
    private var viewModel:BugItListViewModelProtocol?
    private weak var window: UIWindow?
    required init(useCase: BugItListCoordinatorUseCaseProtocol) {
        window = useCase.window
        super.init()
        viewModel = BugItListViewModel(callback: processViewModelCallback(), useCase:GoogelSheetUseCase())
    }

    func start() {
        let view:BugItListViewProtocol & UIViewController = BugItListVC()
        view.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: view)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.navigationController = navigationController
    }
    
    func gotoBugDetail(bugInfo: PresentedDataViewModel){
//        struct UseCase: CharacterDetailCoordinatorUseCaseProtocol {
//            var navigationController: UINavigationController
//            var characterInfo: PresentedDataViewModel
//        }
//        guard let navigationController = navigationController else {
//            return
//        }
//        let coordinator = CharacterDetailCoordinator(
//            useCase: UseCase(navigationController: navigationController,
//                             characterInfo: character))
//        addChild(coordinator)
//        coordinator.start(
//            callback: { [weak self] type in
//                guard let self = self else {
//                    return
//                }
//                switch type {
//                case.back:
//                    self.navigationController?.popViewController(animated: true)
//                }
//            })
    }
}

private extension BugItListCoordinator {
    func processViewModelCallback() ->BugItListViewModelCallback {
        return { [weak self] type in
            switch type {
            case .back:
                break
            case let .gotoBugDetail(itemInfo):
                self?.gotoBugDetail(bugInfo: itemInfo)
            case .uploadBug:
                break
            }
        }
    }
}
