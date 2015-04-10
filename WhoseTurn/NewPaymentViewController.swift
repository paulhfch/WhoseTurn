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
    var payor: String?
    
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
        if payor == nil {
            payor = User.currentUser()!.username
        }
        
        setPayor( payor!, textField: payorTextbox )

        payorPicker = PayorPickerViewController( payors: members )
        payorTextbox.inputView = payorPicker
        
        payorPickerToolBar = InputViewToolBar( parentViewController: self )
        payorPickerToolBar.doneHandler = {
            self.setPayor( self.payorPicker.getSelectedPayor(), textField: self.payorTextbox )
        }

        payorTextbox.inputAccessoryView = payorPickerToolBar
    }
    
    private func setPayor( payor: String, textField: UITextField ){
        textField.text = payor
        membersPicker.update( textField.text, self.members )
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
            membersPicker = segue.destinationViewController as! MemberMultipleSelectionViewController
            membersPicker.members = members
            membersPicker.payor = User.currentUser()!.username
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
        let payorButton = sender as! UIButton
        payorButton.enabled = false
        
        var payment = Payment()
        payment.payor = payorTextbox.text
        payment.group = group
        payment.restaurant = restaurantTextbox.text
        payment.date = DayFormatter.dateFromString( dateTextBox.text )
        payment.paidFor = membersPicker.getSelectedMembers()
        
        payment.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                self.presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
            }
            else {
                payorButton.enabled = true
                
                UIAlertView(title: "Cannot Save Payment Record",
                    message: "Are you connected to the Internet?",
                    delegate: nil,
                    cancelButtonTitle: "OK" ).show()
            }

        }
    }
}