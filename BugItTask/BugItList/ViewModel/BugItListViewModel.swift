//
//  BugItListViewModel.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import Combine
class BugItListViewModel: BugItListViewModelProtocol, ObservableObject {

    // MARK: - Published Variables
    @Published var displayModel = [BugPresentedDataViewModel]()
    @Published var isLoading = false
    // MARK: - Variables
    var actionsSubject = PassthroughSubject<BugItListActions, Never>()
    var callback: BugItListViewModelCallback
    private var cancellables = Set<AnyCancellable>()
    private var useCase: GoogelSheetUseCase
    
    init(callback: @escaping BugItListViewModelCallback, useCase: GoogelSheetUseCase) {
        self.callback = callback
        self.useCase = useCase
    }
    // MARK: - Functions
    
    func viewDidLoad() {
        Task {
            await fetchBugIts()
        }
    }

    
    func refreshData() {
        Task {
            await fetchBugIts()
        }
    }
    
    func bindActions() {
        actionsSubject
            .sink { [weak self] action in
                guard let self = self else{return}
                switch action {
                case .back:
                    self.callback(.back)
                case let  .gotoBugDetail(item):
                    self.callback(.gotoBugDetail(itemInfo: item))
                case .uploadBug:
                    self.callback(.uploadBug)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func fetchBugIts() async {
        do {
            toggleLoading(true)
            let BugItsResult = try await useCase.getBugList()
             toggleLoading(false)
            displayModel.append(contentsOf: BugItsResult.toModels())
        } catch {
            //  dataStatus = .failure(.invalidData)
        }
    }

    
    @MainActor
    func toggleLoading(_ bool: Bool) {
        isLoading = bool
    }
}

extension BugItListViewModel {
    enum BugItListActions {
        case back
        case gotoBugDetail(info:BugPresentedDataViewModel)
        case uploadBug
    }
}
