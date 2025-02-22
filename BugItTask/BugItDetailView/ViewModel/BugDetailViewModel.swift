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
    @Published var isLoading = false
    @Published var isValid = false
    @Published var displayModel: BugPresentedDataViewModel?
    @Published var note: String = "" {
            didSet {
                checkIsValid()
            }
        }

    @Published var bugTitle: String = "" {
            didSet {
                checkIsValid()
            }
        }

    @Published var bugImage: UIImage?
    // MARK: - Variables
    var actionsSubject = PassthroughSubject<BugDetailActions, Never>()
    var callback: BugDetailViewModelCallback
    var uploadedImg: String = ""
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
                case .submitBug:
                    if self.bugTitle.isEmpty || self.note.isEmpty || self.bugTitle.isEmpty{
                        print("Please fill all fields")
                    }else{
                        Task {
                            await self.insertBugInfo(bugImage: self.uploadedImg)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func uploadImage(){
        if let image  = bugImage{
            Task {
                do {
                    await toggleLoading(true)
                    let url = try await FirebaseStorageManager.shared.uploadImage(image)
                    print("Image uploaded: \(url)")
                    self.uploadedImg = url
                    await toggleLoading(false)
                    await checkIsValid()
//                    await insertBugInfo(bugImage: url)
                } catch {
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: Date())
        return formattedDate
    }
    
    @MainActor
    private func insertBugInfo(bugImage:String) async {
        do {
            await toggleLoading(true)
            _ = try await useCase.insertBugInfo(bugName: bugTitle,
                                                bugImage: bugImage,
                                                bugDecription: note,
                                                bugDate: getCurrentDate())
            await toggleLoading(false)
        } catch {
            //  dataStatus = .failure(.invalidData)
        }
    }

    func checkIsValid() {
        if self.uploadedImg.isEmpty || self.note.isEmpty || self.bugTitle.isEmpty{
            isValid = false
        } else{
            isValid = true
        }
    }
    
    
    @MainActor
    func toggleLoading(_ bool: Bool) {
        isLoading = bool
    }
}

extension BugDetailViewModel {
    enum BugDetailActions {
        case back
        case submitBug
    }
}
