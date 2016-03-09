//
//  SecondViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    @IBOutlet weak var collectionView : UICollectionView!
    var refreshControl : UIRefreshControl?
    
    var parsedServiceData : CuriosityRoverData?

    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        spinner.startAnimating()
        
        refresh()
        
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = self.spinner.color
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        collectionView!.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func refresh()
    {
        var page = NSUserDefaults.standardUserDefaults().integerForKey("CURIOSITY_PAGE")
        if page < 1 { page = 1 }
        
        if let date = NSUserDefaults.standardUserDefaults().objectForKey("CURIOSITY_DATE") as? NSDate
        {
            
            CuriosityRoverDataService().getData(date, page: page) { [weak self] (JSON, error) -> Void in
                
                guard error == nil else { print ("SecondViewController.viewDidLoad: \(error)") ; return }
                guard self != nil
                    else
                {
                    print("SecondViewController.viewDidLoad : self was nil on return") ; return
                }
                
                print("[--PARSING JSON--]...")
                self!.parsedServiceData = CuriosityRoverData(JSON: JSON)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("[--RELOADING COLLECTION VIEW--]...")
                    self!.collectionView.reloadData()
                    print("[--STOPPING SPINNER--]...")
                    self!.spinner.stopAnimating()
                    self!.refreshControl?.endRefreshing()
                })
            }
        }
        else
        {
            print("[--ERROR--]: Could not find request parameters in NSUserDefaults")
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return parsedServiceData?.photos.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CuriosityPhotoCell", forIndexPath: indexPath) as! CuriosityPhotoCell
        
        if let photoInfo = parsedServiceData?.photos[indexPath.row], img_src = photoInfo.img_src
        {
            cell.photoInfo = photoInfo
            cell.populateWithImage(img_src)
        }
        else
        {
            cell.photoInfo = nil
            cell.imageView.image = nil
            cell.spinner.stopAnimating()
            print("error: no url for cell image at row \(indexPath.row)")
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let senderCell = sender as? CuriosityPhotoCell, destinationViewController = segue.destinationViewController as? PhotoViewController
        {
            destinationViewController.photoInfo = senderCell.photoInfo
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent;
    }
}

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

class PhotoInfoController : UIViewController
{
    @IBOutlet weak var textView : UITextView?
    weak var photoInfo : CuriosityRoverData.PhotoInfo?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let photoInfo = photoInfo
        {
            textView?.text = "\(photoInfo)"
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