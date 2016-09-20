//
//  CuriosityPhotoCache.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/15/16.
//
//

import Foundation
import UIKit

class CuriosityPhotoCache
{
    static let defaultInstance = CuriosityPhotoCache()
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: self)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receivedMemoryWarning()
    {
        clearImageCache()
    }
    
    
    var inMemoryCache = NSCache<AnyObject, UIImage>()
    
    func clearImageCache()
    {
        inMemoryCache = NSCache()
    }
    
    func getImage(_ imageURL: URL) -> UIImage?
    {
        return inMemoryCache.object(forKey: imageURL.absoluteString as NSString)
    }
    
    func saveImage(_ imageURL: URL, image: UIImage)
    {
        inMemoryCache.setObject(image, forKey: imageURL.absoluteString as NSString)
    }
}
