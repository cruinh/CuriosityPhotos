//
//  CuriosityPhotoRepository.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/15/16.
//
//

import Foundation
import UIKit

class CuriosityPhotoRepository {
    class func getImage(fromURL imageURL: URL, completion:@escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        if let image = CuriosityPhotoCache.defaultInstance.getImage(imageURL) {
            completion(image, nil)
        } else {
            _requestImage(fromURL: imageURL, completion: completion)
        }
    }

    fileprivate class func _requestImage(fromURL imageURL: URL, completion:@escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        DispatchQueue.global(qos: .default).async { () -> Void in
            var maybeImage: UIImage? = nil
            var maybeError: Error? = nil
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data) {
                    maybeImage = image
                    CuriosityPhotoCache.defaultInstance.saveImage(imageURL, image: image)
                } else {
                    maybeError = RepositoryError.badData
                }
            } else {
                maybeError = RepositoryError.badURL
            }

            DispatchQueue.main.async(execute: { () -> Void in
                completion(maybeImage, maybeError)
            })
        }
    }

    enum RepositoryError: Error {
        case badURL
        case badData
    }
}
