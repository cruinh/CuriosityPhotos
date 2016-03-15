//
//  CuriosityPhotoRepository.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/15/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import Foundation
import UIKit

class CuriosityPhotoRepository
{
    static var imageCache = NSCache()
    
    class func clearImageCache()
    {
        imageCache = NSCache()
    }
    
    class func getCachedImage(imageURL: NSURL) -> UIImage?
    {
        return imageCache.objectForKey(imageURL.absoluteString) as? UIImage
    }
    
    class func saveCachedImage(imageURL: NSURL, image: UIImage)
    {
        CuriosityPhotoRepository.imageCache.setObject(image, forKey: imageURL.absoluteString)
    }
    
    class func getImage(imageURL: NSURL, completion:((image: UIImage?, error: Error?)-> Void))
    {
        if let image = CuriosityPhotoRepository.getCachedImage(imageURL)
        {
            completion(image: image, error: nil)
        }
        else
        {
            _requestImage(imageURL, completion: completion)
        }
    }
    
    private class func _requestImage(imageURL: NSURL, completion:((image: UIImage?, error: Error?)-> Void))
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            var maybeImage : UIImage? = nil
            var maybeError : Error? = nil
            if let data = NSData(contentsOfURL: imageURL)
            {
                if let image = UIImage(data: data)
                {
                    maybeImage = image
                    CuriosityPhotoRepository.saveCachedImage(imageURL, image: image)
                }
                else
                {
                    maybeError = Error.BadData
                }
            }
            else
            {
                maybeError = Error.BadURL
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(image: maybeImage, error: maybeError)
            })
        }
    }
    
    enum Error: ErrorType
    {
        case BadURL
        case BadData
    }
}