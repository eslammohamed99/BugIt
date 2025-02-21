//
//  ImagePickerManager.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
import AVFoundation
import Photos

public enum ImagePickerTarget {
    case camera
    case gallery
}

extension ImagePickerTarget {
    var key: String {
        switch self {
        case .camera:
            return "camera"
        case .gallery:
            return "photo gallery"
        }
    }
}

extension ImagePickerTarget {
    var title: String {
        switch self {
        case .camera:
            return "Access to the \(key)"
        case .gallery:
            return "Access to the \(key)"
        }
    }
}

extension ImagePickerTarget {
    var description: String {
        switch self {
        case .camera:
            return "Please provide access to your \(key)"
        case .gallery:
            return "Please provide access to your \(key)"
        }
    }
}


public class ImagePickerManager: NSObject {

    private weak var controller: UIImagePickerController?
    public weak var delegate: ImagePickerDelegate?
    public var cameraPermissionManager = PermissionsManager(type: .camera)
    public var galleryPermissionManager = PermissionsManager(type: .gallery)

    public func dismiss(completion: (() -> Void)? = nil) { controller?.dismiss(animated: true, completion: completion) }
    public func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = sourceType
            self.controller = controller
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    public func openImagePicker(parent viewController: UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let galleryAction = UIAlertAction(
            title: "Gallery",
            style: .default
        ) { [weak self] _ in
            self?.photoGalleryAccessRequest()
        }

        let cameraAction = UIAlertAction(
            title: "Camera",
            style: .default
        ) { [weak self] _ in
            self?.cameraAccessRequest()
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { _ in
            actionSheet.dismiss(animated: true, completion: nil)
        }

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)

        viewController.present(actionSheet, animated: true, completion: nil)
    }

}

public extension ImagePickerManager {
    private func showAlert(targetName: ImagePickerTarget, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: targetName.title,
                                            message: targetName.description,
                                            preferredStyle: .alert)
            let settingAction = UIAlertAction(
                title: "Settings",
                style: .default
            ) { [weak self] _ in
                guard  let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(settingsUrl) else { completion?(false); return }
                UIApplication.shared.open(settingsUrl, options: [:]) { [weak self] _ in
                    self?.showAlert(targetName: targetName, completion: completion)
                }
            }
            alertVC.addAction(settingAction)
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel
            ) { _ in
                completion?(false)
            }
            alertVC.addAction(cancelAction)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?
                .rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }

    func cameraAccessRequest() {
        if delegate == nil { return }
        let source = UIImagePickerController.SourceType.camera
        cameraPermissionManager.requestCamera({ [weak self] status in
            guard let self = self else { return }
            let granted = self.cameraPermissionManager.granted
            switch status {
            case .authorized:
                self.delegate?.imagePicker(self, grantedAccess: true, to: source)
            default:
                if granted {
                    self.delegate?.imagePicker(self, grantedAccess: granted, to: source)

                } else {
                    self.showAlert(
                        targetName: .camera
                    ) { self.delegate?.imagePicker(
                        self,
                        grantedAccess: $0,
                        to: source
                    )
                    }
                }
            }
        })
    }
    func photoGalleryAccessRequest() {
        galleryPermissionManager.requestGallery { [weak self] result in
            let source = UIImagePickerController.SourceType.photoLibrary
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.imagePicker(self, grantedAccess: result == .authorized, to: source)
                }
            } else {
                self.showAlert(
                    targetName: .gallery
                ) { self.delegate?.imagePicker(
                    self,
                    grantedAccess: $0,
                    to: source
                )
                }
            }
        }
    }
}
// MARK: UINavigationControllerDelegate
extension ImagePickerManager: UINavigationControllerDelegate { }
extension ImagePickerManager: UIImagePickerControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage,
           let format = getImageFormat(info: info) {
            delegate?.imagePicker(self, didSelect: image, imageFormat: format)
            return
        }
        if let image = info[.originalImage] as? UIImage,
           let format = getImageFormat(info: info) {
            delegate?.imagePicker(self, didSelect: image, imageFormat: format)
        } else {
            print("Other source")
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        delegate?.cancelButtonDidClick(on: self)
    }

    private func getImageFormat(info: [UIImagePickerController.InfoKey: Any]) -> UIImage.ImageFormat? {
        guard let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? URL else {
            return .JPEG
        }
        if assetPath.absoluteString.hasSuffix("JPG") {
            return .JPEG
        } else if assetPath.absoluteString.hasSuffix("PNG") {
            return .PNG
        } else if assetPath.absoluteString.hasSuffix("GIF") {
            return .GIF
        } else if assetPath.absoluteString.hasSuffix("JPEG") {
            return .JPEG
        } else if assetPath.absoluteString.hasSuffix("HEIC") {
            return .HEIC
        } else {
            return nil
        }
    }
}
