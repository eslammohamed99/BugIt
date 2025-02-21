//
//  ImagePickerPermission.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UserNotifications
import Foundation
import AVFoundation
import Photos


public typealias Callback = (PermissionStatus) -> Void

protocol PermissionEngine: AnyObject {
    var type: PermissionType { get }
    var status: PermissionStatus { get }

    func requestAuthorization(_ callback: @escaping Callback)
    func callbacks(_ with: PermissionStatus)
}
public enum PermissionStatus: String {
    case authorized = "Authorized"
    case denied = "Denied"
    case disabled = "Disabled"
    case notDetermined = "Not Determined"

    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }
}

public enum PermissionType {
    case camera
    case gallery
}

extension PermissionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .camera: return "Camera"
        case .gallery: return "Gallery"
        }
    }
}

public class PermissionsManager: PermissionEngine {
    public var type: PermissionType
    public var granted: Bool = false
    public var status: PermissionStatus {
        switch type {
        case .camera: return statusCamera
        case .gallery:  return statusGallery
        }
    }

    var callback: Callback?

    public init(type: PermissionType) {
        self.type = type
    }

    func requestAuthorization(_ callback: @escaping Callback) {
        switch type {
        case .camera: requestCamera(callback)
        case .gallery: requestGallery(callback)
        }
    }

    func callbacks(_ with: PermissionStatus) {
        DispatchQueue.main.async {
            self.callback?(self.status)
        }
    }
}


public extension PermissionsManager {
    var statusCamera: PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized: return .authorized
        case .restricted, .denied: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    func requestCamera(_ callback: @escaping Callback) {
        if Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") != nil {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.granted = granted
                callback(self.statusCamera)
            }
        } else {
            debugPrint("WARNING: NSCameraUsageDescription not found in Info.plist")
        }
    }
}


public extension PermissionsManager {
    var statusGallery: PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized: return .authorized
        case .restricted, .denied: return .denied
        case .notDetermined: return .notDetermined
        case .limited: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    func requestGallery(_ callback: @escaping Callback) {
        if Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") != nil {
            PHPhotoLibrary.requestAuthorization { _ in
                callback(self.statusGallery)
            }
        } else {
            debugPrint("WARNING: NSPhotoLibraryUsageDescription not found in Info.plist")
        }
    }
}
