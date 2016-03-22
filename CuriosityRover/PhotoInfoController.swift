//
//  PhotoInfoController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/9/16.
//
//

import Foundation
import UIKit

class PhotoInfoController : UIViewController
{
    @IBOutlet weak var textView : UITextView?
    weak var photoInfo : CuriosityRoverData.PhotoInfo?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Photo JSON data"
        if let photoInfo = photoInfo
        {
            textView?.text = "\(photoInfo)"
            textView?.contentOffset = CGPointZero
        }
        else
        {
            print("error: photo info unavailable")
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    @IBAction func dismiss()
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}