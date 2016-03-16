//
//  CuriosityPhotoCache.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/15/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import Foundation
import UIKit

class CuriosityPhotoCache
{
    private static var s_instance: CuriosityPhotoCache!
    private static var s_instance_token : dispatch_once_t = 0
    
    class func defaultInstance() -> CuriosityPhotoCache
    {
        dispatch_once(&CuriosityPhotoCache.s_instance_token) { () -> Void in
            CuriosityPhotoCache.s_instance = CuriosityPhotoCache()
            
        }
        return CuriosityPhotoCache.s_instance
    }
    
    init()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receivedMemoryWarning"), name: UIApplicationDidReceiveMemoryWarningNotification, object: self)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func receivedMemoryWarning()
    {
        clearImageCache()
    }
    
    
    var inMemoryCache = NSCache()
    
    func clearImageCache()
    {
        inMemoryCache = NSCache()
    }
    
    func getImage(imageURL: NSURL) -> UIImage?
    {
        return inMemoryCache.objectForKey(imageURL.absoluteString) as? UIImage
    }
    
    func saveImage(imageURL: NSURL, image: UIImage)
    {
        inMemoryCache.setObject(image, forKey: imageURL.absoluteString)
    }
}