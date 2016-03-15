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
    static var imageCache = [String:UIImage]()
    
    class func clearImageCache()
    {
        imageCache = [String:UIImage]()
    }
    
    class func getImage(imageURL: NSURL, completion:((image: UIImage?, error: Error?)-> Void))
    {
        if let image = CuriosityPhotoRepository.imageCache[imageURL.absoluteString]
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
                    CuriosityPhotoRepository.imageCache[imageURL.absoluteString] = image
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