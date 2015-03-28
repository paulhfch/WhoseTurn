//
//  NewPaymentViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class NewPaymentViewController : UITableViewController {
    
    var group: String!
    var members: [User]!
    
    @IBOutlet weak var payorTextbox: UITextField!
    @IBOutlet weak var dateTextBox: UITextField!
    @IBOutlet weak var restaurantTextbox: UITextField!
    
    var payorPickerToolbar: InputToolBarViewController!
    var datePicker: DatePicker!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePayorField()
        configureDateField()
    }
    
    private func configurePayorField() {
        payorTextbox.text = PFUser.currentUser().username
        payorTextbox.inputView = PayorPickerViewController( payors: members, textField: payorTextbox )
    }
    
    private func configureDateField() {
        let now = NSDate()
        dateTextBox.text = DayFormatter.stringFromDate( now )

        datePicker = DatePicker( textField: dateTextBox )
        dateTextBox.inputView = datePicker.view
    }
    
    // MARK: Actions
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
    }
    
    @IBAction func onElseWhereTapped(sender: AnyObject) {
        // dismisses any input view
        view.endEditing( true )
    }
    
    @IBAction func onPayButtonTapped(sender: AnyObject) {
        var payment = Payment()
        payment.payor = payorTextbox.text
        payment.group = group
        payment.restaurant = restaurantTextbox.text
        payment.date = DayFormatter.dateFromString( dateTextBox.text )
        
        payment.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            self.presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
            
            return
        }
    }
}