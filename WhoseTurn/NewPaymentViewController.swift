//
//  NewPaymentViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class NewPaymentViewController : UITableViewController {
    
    let showMembersSegueId = "showMembers"
    
    var group: String!
    var members: [User]!
    
    @IBOutlet weak var payorTextbox: UITextField!
    @IBOutlet weak var dateTextBox: UITextField!
    @IBOutlet weak var restaurantTextbox: UITextField!
    
    var payorPicker: PayorPickerViewController!
    var datePicker: UIDatePicker!
    weak var membersPicker: MemberMultipleSelectionViewController!
    
    var payorPickerToolBar: InputViewToolBar!
    var datePickerToolBar: InputViewToolBar!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePayorField()
        configureDateField()
    }
    
    private func configurePayorField() {
        payorTextbox.text = PFUser.currentUser().username
        
        payorPicker = PayorPickerViewController( payors: members )
        payorTextbox.inputView = payorPicker
        
        payorPickerToolBar = InputViewToolBar( parentViewController: self )
        payorPickerToolBar.doneHandler = {
            self.payorTextbox.text = self.payorPicker.getSelectedPayor()
            self.membersPicker.update( self.payorTextbox.text, self.members )
        }

        payorTextbox.inputAccessoryView = payorPickerToolBar
    }
    
    private func configureDateField() {
        let now = NSDate()
        dateTextBox.text = DayFormatter.stringFromDate( now )

        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateTextBox.inputView = datePicker
        
        datePickerToolBar = InputViewToolBar( parentViewController: self )
        datePickerToolBar.doneHandler = {
            self.dateTextBox.text = DayFormatter.stringFromDate( self.datePicker.date )
        }
        
        dateTextBox.inputAccessoryView = datePickerToolBar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showMembersSegueId {
            membersPicker = segue.destinationViewController as MemberMultipleSelectionViewController
            membersPicker.members = members
            membersPicker.payor = PFUser.currentUser().username
        }
    }
    
    // MARK: Actions
    @IBAction func onPayorChanged(sender: AnyObject) {
        membersPicker.update( payorTextbox.text, members )
    }
    
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
        payment.paidFor = membersPicker.getSelectedMembers()
        
        // MARK: TODO some validation here please
        
        payment.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            self.presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
            
            return
        }
    }
}