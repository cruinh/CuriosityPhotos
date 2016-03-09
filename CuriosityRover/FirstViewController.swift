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

class FirstViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var pageTextField: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissPickerButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        populateValues()
        
        dismissPickerButton.backgroundColor = UIColor.blackColor()
        
        saveSelectedValues()
        
        hideDatePicker(false)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func populateValues()
    {
        let date : NSDate!
        if let savedDate = NSUserDefaults.standardUserDefaults().objectForKey("CURIOSITY_DATE") as? NSDate
        {
            date = savedDate
        }
        else
        {
            date = yesterDay()
        }
        datePicker.date = date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        
        dateTextField.text = dateString
        
        var page = NSUserDefaults.standardUserDefaults().integerForKey("CURIOSITY_PAGE")
        if page < 1
        {
            page = 1
        }
        pageTextField.text = "\(page)"
    }
    
    private func saveSelectedValues()
    {
        let date = datePicker.date
        let page = Int(pageTextField.text ?? "1") ?? 1
        
        NSUserDefaults.standardUserDefaults().setObject(date, forKey: "CURIOSITY_DATE")
        NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "CURIOSITY_PAGE")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func showDatePicker()
    {
        view.layoutIfNeeded()
        
        dismissPickerButton.hidden = false
        datePickerBottomConstraint.constant = 0
        
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0.5
            self?.view.layoutIfNeeded()
        }
    }
    
    private func hideDatePicker(animated: Bool = true)
    {
        view.layoutIfNeeded()
        
        datePickerBottomConstraint.constant = (0 - datePicker.bounds.size.height)
        dismissPickerButton.hidden = true
        
        if animated
        {
            UIView.animateWithDuration(0.2) { [weak self] () -> Void in
                self?.dismissPickerButton.alpha = 0
                self?.view.layoutIfNeeded()
            }
        }
        else
        {
            dismissPickerButton.alpha = 0
            view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTapDate(sender: AnyObject)
    {
        showDatePicker()
    }
    
    @IBAction func didTapDismissPickerButton(sender: AnyObject)
    {
        pageTextField.resignFirstResponder()
        hideDatePicker()
        saveSelectedValues()
        populateValues()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .Default;
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        dismissPickerButton.hidden = false
        
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0.5
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        saveSelectedValues()
        populateValues()
        
        dismissPickerButton.hidden = true
        
        UIView.animateWithDuration(0.2) { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0
        }
    }
}

