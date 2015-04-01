//
//  SignUpViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-31.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var groupNameText: UITextField!
    @IBOutlet weak var groupCode: UITextField!
    
    // MARK: Actions
    @IBAction func onSignUpButtonTapped(sender: AnyObject) {
        if missingRequiredFields() {
            UIAlertView(title: "Missing Information",
                message: "Please fill out the required information",
                delegate: nil,
                cancelButtonTitle: "OK" ).show()
        }
        else {
            signUp()
        }
    }
    
    private func signUp() {
        var newUser = User()
        
        newUser.username = usernameText.text
        newUser.password = passwordText.text
        
        if joiningGroup() && validGroupName() {
            newUser.groups = [ groupNameText.text ]
        }
        
        newUser.signUpInBackgroundWithBlock { ( success: Bool, error: NSError!) -> Void in
            if success {
                self.presentingViewController?.dismissViewControllerAnimated( true, completion: { () -> Void in
                    
                    PFUser.logInWithUsername( newUser.username, password: newUser.password )
                    self.presentingViewController?.performSegueWithIdentifier( showGroupsSegueId, sender: nil )
                })
            }
            else {
                UIAlertView(title: "Cannot Sign Up",
                    message: error.userInfo?["error"] as? String,
                    delegate: nil,
                    cancelButtonTitle: "OK" ).show()
            }
        }
    }
    
    private func missingRequiredFields() -> Bool {
        if usernameText.text == "" {
            return true
        }
        
        if passwordText.text == "" {
            return true
        }
        
        if groupNameText.text != "" || groupCode.text != "" {
            if groupNameText.text == "" || groupCode.text == "" {
                return true
            }
        }
        
        return false
    }
    
    private func joiningGroup() -> Bool {
        return groupNameText.text != "" && groupCode.text != ""
    }
    
    private func validGroupName() -> Bool {
        return groupCode.text == VerificationCode( from: groupNameText.text ).code
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
    }
}
