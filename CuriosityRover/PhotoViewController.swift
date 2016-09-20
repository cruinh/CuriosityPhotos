//
//  PhotoViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/9/16.
//
//

import Foundation
import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    weak var image: UIImage?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var photoInfo: CuriosityRoverData.PhotoInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView?.minimumZoomScale = 1.0
        self.scrollView?.maximumZoomScale = 6.0

        populatePhoto()
        refreshTitle()
    }

    func populatePhoto() {
        if let imageURL = photoInfo?.img_src {
            activityIndicator?.startAnimating()
            CuriosityPhotoRepository.getImage(fromURL: imageURL, completion: { [weak self](image, error) -> Void in
                guard self != nil else { print("self was nil: \(#file):\(#line)"); return }

                if let image = image {
                    self!.imageView?.image = image
                } else {
                    print("error: photo url invalid: \(imageURL)")
                }

                self!.activityIndicator?.stopAnimating()
                })
        } else {
            print("error: photo url was nil")
        }
    }

    func refreshTitle() {
        var titleString = photoInfo?.camera?.name ?? ""
        if let earthDate = photoInfo?.earth_date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            titleString = titleString + " " + dateFormatter.string(from: earthDate as Date)
        }
        title = titleString
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PhotoInfoController {
            destinationViewController.photoInfo = self.photoInfo
        }
    }

    @IBAction func dismiss(_ sender: UIButton?) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
