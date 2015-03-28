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
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
    }
    
    // dismiss input views
    @IBAction func onElseWhereTapped(sender: AnyObject) {
        view.endEditing( true )
    }
}