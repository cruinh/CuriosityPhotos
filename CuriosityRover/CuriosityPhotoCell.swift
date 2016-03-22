//
//  CuriosityPhotoCell.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import Foundation
import UIKit

class CuriosityPhotoCell : UICollectionViewCell
{   
    var photoInfo : CuriosityRoverData.PhotoInfo?
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    func populateWithImage(imageURL: NSURL)
    {
        spinner.startAnimating()
        backgroundColor = UIColor.darkGrayColor()
        imageView.image = nil
        
        CuriosityPhotoRepository.getImage(imageURL, completion: { [weak self] (image, error) -> Void in
            
            guard self != nil else { print("self was nil: \(__FILE__):\(__LINE__)"); return }
            guard error == nil else { print("[--ERROR--]: \(__FILE__):\(__LINE__)\n\(error)"); return }
            
            self!.imageView.image = image
            self!.spinner.stopAnimating()
            
            defer{ self?.spinner.stopAnimating() }
            
        })
    }
}