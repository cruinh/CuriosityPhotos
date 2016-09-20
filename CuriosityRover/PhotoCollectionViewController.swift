//
//  PhotoCollectionViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        refreshControl!.addTarget(self, action: #selector(PhotoCollectionViewController.refresh), for: UIControlEvents.valueChanged)
        collectionView!.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(_ animated: Bool)
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
            
            DispatchQueue.main.async(execute: { () -> Void in
                print("[--RELOADING COLLECTION VIEW--]...")
                self!.collectionView.reloadData()
                print("[--STOPPING SPINNER--]...")
                self!.spinner.stopAnimating()
                self!.refreshControl?.endRefreshing()
            })
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard parsedServiceData?.photos.count > 0 else
        {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "NoResultsCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuriosityPhotoCell", for: indexPath) as! CuriosityPhotoCell
        
        if let photoInfo = parsedServiceData?.photos[(indexPath as NSIndexPath).row], let img_src = photoInfo.img_src
        {
            cell.photoInfo = photoInfo
            cell.populate(withImage: img_src)
        }
        else
        {
            cell.photoInfo = nil
            cell.imageView.image = nil
            cell.spinner.stopAnimating()
            print("error: no url for cell image at row \((indexPath as NSIndexPath).row)")
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let senderCell = sender as? CuriosityPhotoCell,
            let destinationController = segue.destination as? UINavigationController,
            let destinationPhotoController = destinationController.topViewController as? PhotoViewController
        {
            destinationPhotoController.photoInfo = senderCell.photoInfo
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent;
    }
}
