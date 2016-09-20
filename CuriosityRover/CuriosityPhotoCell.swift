//
//  CuriosityPhotoCell.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import Foundation
import UIKit

class CuriosityPhotoCell: UICollectionViewCell {
    var photoInfo: CuriosityRoverData.PhotoInfo?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    func populate(withImage imageURL: URL) {
        spinner.startAnimating()
        backgroundColor = UIColor.darkGray
        imageView.image = nil

        CuriosityPhotoRepository.getImage(fromURL: imageURL, completion: { [weak self] (image, error) -> Void in

            guard self != nil else { print("self was nil: \(#file):\(#line)"); return }
            guard error == nil else { print("[--ERROR--]: \(#file):\(#line)\n\(error)"); return }

            self!.imageView.image = image
            self!.spinner.stopAnimating()

            defer { self?.spinner.stopAnimating() }

        })
    }
}
