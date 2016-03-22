//
//  OptionsViewController.swift
//  CuriosityRover
//
//  Created by Matt Hayes on 3/4/16.
//
//

import UIKit

class OptionsViewController: UIViewController, UITextFieldDelegate
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
        let options = CuriosityRoverDataService.Options()
        datePicker.date = options.date
        dateTextField.text = options.dateString
        pageTextField.text = "\(options.page)"
    }
    
    private func saveSelectedValues()
    {
        let date = datePicker.date
        let page = Int(pageTextField.text ?? "1") ?? 1
        
        let options = CuriosityRoverDataService.Options(date: date, page: page)
        options.save()
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

