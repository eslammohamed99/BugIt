//
//  BugDetailViewModel.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import Combine
import UIKit
class BugDetailViewModel: BugDetailViewModelProtocol, ObservableObject {

    // MARK: - Published Variables
    
    @Published var displayModel: BugPresentedDataViewModel?
    @Published var note = ""
    @Published var bugImage: UIImage?
    // MARK: - Variables
    var actionsSubject = PassthroughSubject<BugDetailActions, Never>()
    var callback: BugDetailViewModelCallback
    private var cancellables = Set<AnyCancellable>()
    init(displayModel: BugPresentedDataViewModel?, callback: @escaping BugDetailViewModelCallback) {
        self.displayModel = displayModel
        self.callback = callback
    }
    // MARK: - Functions
    func viewDidLoad() {

    }
    
    func bindActions() {
        actionsSubject
            .sink { [weak self] action in
                guard let self = self else{return}
                switch action {
                case .back:
                    self.callback(.back)
                }
            }
            .store(in: &cancellables)
    }
}

extension BugDetailViewModel {
    enum BugDetailActions {
        case back
    }
}
