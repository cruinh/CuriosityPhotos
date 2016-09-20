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
        
        dismissPickerButton.backgroundColor = UIColor.black
        
        saveSelectedValues()
        
        hideDatePicker(false)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    fileprivate func populateValues()
    {
        let options = CuriosityRoverDataService.Options()
        datePicker.date = options.date as Date
        dateTextField.text = options.dateString
        pageTextField.text = "\(options.page)"
    }
    
    fileprivate func saveSelectedValues()
    {
        let date = datePicker.date
        let page = Int(pageTextField.text ?? "1") ?? 1
        
        let options = CuriosityRoverDataService.Options(date: date, page: page)
        options.save()
    }
    
    fileprivate func showDatePicker()
    {
        view.layoutIfNeeded()
        
        dismissPickerButton.isHidden = false
        datePickerBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0.5
            self?.view.layoutIfNeeded()
        }) 
    }
    
    fileprivate func hideDatePicker(_ animated: Bool = true)
    {
        view.layoutIfNeeded()
        
        datePickerBottomConstraint.constant = (0 - datePicker.bounds.size.height)
        dismissPickerButton.isHidden = true
        
        if animated
        {
            UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
                self?.dismissPickerButton.alpha = 0
                self?.view.layoutIfNeeded()
            }) 
        }
        else
        {
            dismissPickerButton.alpha = 0
            view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTapDate(_ sender: AnyObject)
    {
        showDatePicker()
    }
    
    @IBAction func didTapDismissPickerButton(_ sender: AnyObject)
    {
        pageTextField.resignFirstResponder()
        hideDatePicker()
        saveSelectedValues()
        populateValues()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .default;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        dismissPickerButton.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0.5
        }) 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        saveSelectedValues()
        populateValues()
        
        dismissPickerButton.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
            self?.dismissPickerButton.alpha = 0
        }) 
    }
}

