//
//  Untitled.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import SwiftUI

struct BugDetailUIView: View {
    @ObservedObject  var viewModel: BugDetailViewModel
    var clickOnAction: (()->())?

    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            CustomNavigationBar(title: viewModel.displayModel?.name ?? "New Bug") {
                viewModel.actionsSubject.send(.back)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    if let image = viewModel.displayModel?.image{
                        Image(image)
                            .resizable()
                    }
                    else if let image = viewModel.bugImage{
                        Image(uiImage: image)
                            .resizable()
                    }
                    else{
                        Button {
                            clickOnAction?()
                        } label: {
                            Text("upload Bug Image")
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }.frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 20)
                if let descrip = viewModel.displayModel?.decription{
                    Text(descrip).font(.system(size: 16, weight: .medium))
                }
                else{
                    Text("Add Bug Description").font(.system(size: 16, weight: .bold))
                    ScrollView {
                        VStack {
                            AttributedTextView(
                                text: $viewModel.note,
                                attributedPlaceholder: "Add Description"
                            ) { string in
                                return string
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                Spacer()
                if viewModel.displayModel == nil{
                    Button {
                        
                    } label: {
                        Text("Submit Bug")
                            .foregroundStyle(.white)
                    }.frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(9999)
                        .padding(.horizontal, 10)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
        .ignoresSafeArea(SafeAreaRegions.all, edges: .top)
    }
}

extension BugDetailView: ImagePickerDelegate {
    func imagePicker(
        _ imagePicker: ImagePickerManager,
        grantedAccess: Bool,
        to sourceType: UIImagePickerController.SourceType
    ) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }

    func imagePicker(_ imagePicker: ImagePickerManager, didSelect image: UIImage, imageFormat: UIImage.ImageFormat) {
        print(image.size.width)
        // Image Picked Here
        // Should passed to swfitui view
        bugDetailUIView?.viewModel.bugImage = image
        imagePicker.dismiss()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        let imageAspectRatio = image.size.width / image.size.height
//        noteInput.setMediaView(view: imageView,
//                               aspectRatio: imageAspectRatio)
        guard let data = image.compressImage(maxMegaByte: 3) else {
            return
        }
        bugDetailUIView?.viewModel.uploadImage()
//        let model = UploadImageModel(action: .profileImage, data: data, format: imageFormat)
//        callback?(.imageUpload(model: model))

    }
}
