//
//  PhotoViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/9/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController : UIViewController
{
    weak var image : UIImage?
    @IBOutlet weak var imageView : UIImageView?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var photoInfo : CuriosityRoverData.PhotoInfo?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let urlString = photoInfo?.img_src?.absoluteString
        {
            imageView?.image = CuriosityPhotoCell.imageFromCache(urlString)
        }
        else
        {
            print("error: photo url invalid: \(photoInfo?.img_src)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? PhotoInfoController
        {
            destinationViewController.photoInfo = self.photoInfo
        }
    }
    
    @IBAction func dismiss()
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}