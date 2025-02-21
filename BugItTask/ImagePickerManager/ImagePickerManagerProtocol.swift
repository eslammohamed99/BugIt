//
//  ImagePickerManagerProtocol.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit
import AVFoundation
import Photos

public protocol ImagePickerDelegate: AnyObject {
    func imagePicker(_ imagePicker: ImagePickerManager, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType)
    func imagePicker(_ imagePicker: ImagePickerManager, didSelect image: UIImage, imageFormat: UIImage.ImageFormat)
    func cancelButtonDidClick(on imagePicker: ImagePickerManager)
}

public extension ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePickerManager, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {}
    func imagePicker(_ imagePicker: ImagePickerManager, didSelect image: UIImage, imageFormat: UIImage.ImageFormat) {}
    func cancelButtonDidClick(on imagePicker: ImagePickerManager) {}
}
