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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePayorField()
        configureDateField()
    }
    
    private func configurePayorField() {
        payorTextbox.text = PFUser.currentUser().username
        
        // http://stackoverflow.com/a/22349340
        // use picker view to fill in text fields
        
        payorTextbox.inputView = PayorPickerViewController( payors: members )
        
        payorPickerToolbar = InputToolBarViewController()
        payorPickerToolbar.okayHandler = {
            //TODO
            
            self.view.endEditing( true )
            return
        }
        payorPickerToolbar.cancelHandler = {
            // dismiss picker input view
            self.view.endEditing( true )
            return
        }
        
        payorTextbox.inputAccessoryView = payorPickerToolbar.view
    }
    
    private func configureDateField() {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate( "yyyy-MM-dd zzz" )
        dateTextBox.text = formatter.stringFromDate( now )

        
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
    }
}