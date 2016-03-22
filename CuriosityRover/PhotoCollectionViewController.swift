//
//  PhotoCollectionViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import UIKit

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    @IBOutlet weak var collectionView : UICollectionView!
    var refreshControl : UIRefreshControl?
    
    var parsedServiceData : CuriosityRoverData?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        parsedServiceData = nil
        collectionView.reloadData()
        spinner.startAnimating()
        
        CuriosityRoverDataService().getData() { [weak self] (JSON, error) -> Void in
            
            guard error == nil else { print ("PhotoCollectionViewController.viewDidLoad: \(error)") ; return }
            guard self != nil
                else
            {
                print("PhotoCollectionViewController.viewDidLoad : self was nil on return") ; return
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let parsedServiceData = parsedServiceData else { return 0 }
        
        if parsedServiceData.photos.count > 0
        {
            return parsedServiceData.photos.count
        }
        else
        {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        guard parsedServiceData?.photos.count > 0 else
        {
            return collectionView.dequeueReusableCellWithReuseIdentifier("NoResultsCell", forIndexPath: indexPath)
        }
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let senderCell = sender as? CuriosityPhotoCell,
            destinationController = segue.destinationViewController as? UINavigationController,
            destinationPhotoController = destinationController.topViewController as? PhotoViewController
        {
            destinationPhotoController.photoInfo = senderCell.photoInfo
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent;
    }
}