//
//  PhotoViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/9/16.
//
//

import Foundation
import UIKit

class PhotoViewController : UIViewController, UIScrollViewDelegate
{
    weak var image : UIImage?
    @IBOutlet weak var imageView : UIImageView?
    @IBOutlet weak var scrollView : UIScrollView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var photoInfo : CuriosityRoverData.PhotoInfo?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scrollView?.minimumZoomScale = 1.0
        self.scrollView?.maximumZoomScale = 6.0
        
        populatePhoto()
        refreshTitle()
    }
    
    func populatePhoto()
    {
        if let imageURL = photoInfo?.img_src
        {
            activityIndicator?.startAnimating()
            CuriosityPhotoRepository.getImage(imageURL, completion: { [weak self](image, error) -> Void in
                guard self != nil else { print("self was nil: \(__FILE__):\(__LINE__)"); return }
                
                if let image = image
                {
                    self!.imageView?.image = image
                }
                else
                {
                    print("error: photo url invalid: \(imageURL)")
                }
                
                self!.activityIndicator?.stopAnimating()
                })
        }
        else
        {
            print("error: photo url was nil")
        }
    }
    
    func refreshTitle()
    {
        var titleString = photoInfo?.camera?.name ?? ""
        if let earthDate = photoInfo?.earth_date
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            titleString = titleString + " " + dateFormatter.stringFromDate(earthDate)
        }
        title = titleString
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.imageView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? PhotoInfoController
        {
            destinationViewController.photoInfo = self.photoInfo
        }
    }

    @IBAction func dismiss(sender: UIButton?)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}