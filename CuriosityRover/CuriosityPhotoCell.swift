//
//  CuriosityPhotoCell.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import Foundation
import UIKit

var imageCache = [String:UIImage]()

class CuriosityPhotoCell : UICollectionViewCell
{
    class func imageFromCache(urlString : String) -> UIImage?
    {
        return imageCache[urlString]
    }
    
    class func clearImageCache()
    {
        imageCache = [String:UIImage]()
    }
    
    var photoInfo : CuriosityRoverData.PhotoInfo?
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    func populateWithImage(imageURL: NSURL)
    {
        imageView.image = nil
        
        if let image = imageCache[imageURL.absoluteString]
        {
            imageView.image = image
        }
        else
        {
            spinner.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self]() -> Void in
                
                if let data = NSData(contentsOfURL: imageURL)
                {
                    imageCache[imageURL.absoluteString] = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self?.imageView.image = UIImage(data: data)
                        self!.spinner.stopAnimating()
                    })
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self?.imageView.image = nil
                        self!.spinner.stopAnimating()
                    })
                }
                
            }
        }
    }
}