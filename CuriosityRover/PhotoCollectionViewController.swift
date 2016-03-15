//
//  PhotoCollectionViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//  Copyright © 2016 uShip. All rights reserved.
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
        
        spinner.startAnimating()
        refresh()
    }
    
    func refresh()
    {
        CuriosityRoverDataService().getData() { [weak self] (JSON, error) -> Void in
            
            guard error == nil else { print ("OptionsViewController.viewDidLoad: \(error)") ; return }
            guard self != nil
                else
            {
                print("OptionsViewController.viewDidLoad : self was nil on return") ; return
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