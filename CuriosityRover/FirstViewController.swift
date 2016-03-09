//
//  FirstViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//  Copyright © 2016 uShip. All rights reserved.
//

import UIKit

func yesterDay() -> NSDate
{
    let today: NSDate = NSDate()
    
    let daysToAdd:Int = -1
    
    // Set up date components
    let dateComponents: NSDateComponents = NSDateComponents()
    dateComponents.day = daysToAdd
    
    // Create a calendar
    let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    let yesterDayDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: today, options:NSCalendarOptions(rawValue: 0))!
    
    return yesterDayDate
}

class FirstViewController: UIViewController
{
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var pageTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //TODO: update this so it's changable from the UI
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = yesterDay()
        let dateString = dateFormatter.stringFromDate(date)
        
        dateTextField.text = dateString
        
        let page = 1
        pageTextField.text = "\(page)"
        
        NSUserDefaults.standardUserDefaults().setObject(date, forKey: "CURIOSITY_DATE")
        NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "CURIOSITY_PAGE")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

