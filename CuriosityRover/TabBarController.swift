//
//  TabBarController.swift
//  CuriosityRover
//
//  Created by Matthew Hayes on 3/15/16.
//
//

import Foundation
import UIKit

class TabBarController : UITabBarController, UITabBarControllerDelegate
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
    {
        if let viewController = viewController as? PhotoCollectionViewController
        {
            viewController.refresh()
        }
    }
}