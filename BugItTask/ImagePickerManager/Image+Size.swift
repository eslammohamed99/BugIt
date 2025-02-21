//
//  Image+Size.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import Foundation
import UIKit

public extension UIImage {
    enum ImageFormat: String {
        case PNG = "png"
        case JPEG = "jpg"
        case GIF = "gif"
        case TIFF = "tiff"
        case HEIC = "heic"
        public var mimeValue: String {
            switch self {
            case .PNG:
                return "image/png"
            case .JPEG:
                return "image/jpeg"
            case .GIF:
                return "image/gif"
            case .TIFF:
                return "image/tiff"
            case .HEIC:
                return "image/jpeg"
            }
        }
    }

    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    enum DataUnits: String {
        case byte
        case kilobyte
        case megabyte
        case gigabyte
    }

    func compressImage(maxMegaByte megaByte: Double) -> Data? {
        let imageSize = self.getSizeIn(.megabyte)
        if imageSize > megaByte {
            let compressionRatio = (megaByte / imageSize)
            return self.jpegData(compressionQuality: compressionRatio)
        } else {
            return self.jpegData(compressionQuality: 1)
        }
    }

    func getSizeIn(_ type: DataUnits) -> Double {
        guard let data = jpegData(compressionQuality: 1) else {
            return 0
        }
        var size: Double = 0.0
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        return size
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
