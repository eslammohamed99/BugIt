//
//  FirebaseUploadManager.swift
//  BugItTask
//
//  Created by Eslam Mohamed on 21/02/2025.
//

import UIKit
import FirebaseStorage


class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(.invalidData))
            return
        }
        
        // Create unique filename
        let filename = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child("bug-images/\(filename)")
        
        // Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload data
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(.failed))
                return
            }
            
            // Get download URL
            storageRef.downloadURL { url in
                switch url{
                    case .success(let url):
//                    guard let downloadURL = url.absoluteString else {
//                        completion(.failure(.failed))
//                        return
//                    }
                    completion(.success(url.absoluteString))
                case .failure(let error):
                    completion(.failure(.failed))
                    return
                }
                
            }
        }
    }
    
    // Async/await version
    func uploadImage(_ image: UIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            uploadImage(image) { result in
                continuation.resume(with: result)
            }
        }
    }
}
