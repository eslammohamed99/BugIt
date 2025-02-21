//
//  BugDetailViewModel.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import Combine
import UIKit
import FirebaseStorage

class BugDetailViewModel: BugDetailViewModelProtocol, ObservableObject {

    // MARK: - Published Variables
    
    @Published var displayModel: BugPresentedDataViewModel?
    @Published var note = ""
    @Published var bugImage: UIImage?
    // MARK: - Variables
    var actionsSubject = PassthroughSubject<BugDetailActions, Never>()
    var callback: BugDetailViewModelCallback
    private var useCase: GoogelSheetUseCase
    private var cancellables = Set<AnyCancellable>()
    init(displayModel: BugPresentedDataViewModel?, callback: @escaping BugDetailViewModelCallback, useCase: GoogelSheetUseCase) {
        self.displayModel = displayModel
        self.callback = callback
        self.useCase = useCase
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
    
    func uploadImage(){
        if let image  = bugImage{
            Task {
                do {
                    let url = try await FirebaseStorageManager.shared.uploadImage(image)
                    print("Image uploaded: \(url)")
                    await insertBugInfo()
                    
                } catch {
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @MainActor
    private func insertBugInfo() async {
        do {
            //toggleLoading(true)
            let BugItsResult = try await useCase.insertBugInfo()
            // toggleLoading(false)
        } catch {
            //  dataStatus = .failure(.invalidData)
        }
    }
}

extension BugDetailViewModel {
    enum BugDetailActions {
        case back
    }
}
