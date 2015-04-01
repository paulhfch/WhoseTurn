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
    @IBOutlet weak var groupCodeText: UITextField!
    
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
        
        if joiningGroup() && validGroupCode() {
            newUser.groups = [ groupNameText.text ]
        }
        else {
            UIAlertView(title: "Joining Group",
                message: "Group does not exist or group name does not match group code",
                delegate: nil,
                cancelButtonTitle: "Try Again" ).show()
            
            return
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
        
        if groupNameText.text != "" || groupCodeText.text != "" {
            if groupNameText.text == "" || groupCodeText.text == "" {
                return true
            }
        }
        
        return false
    }
    
    private func joiningGroup() -> Bool {
        return groupNameText.text != "" && groupCodeText.text != ""
    }
    
    private func validGroupCode() -> Bool {
        if let group = Group.getGroupWithName( groupNameText.text ) {
            let groupCode = VerificationCode( from: group ).code
            return groupCodeText.text == groupCode
        }
        else {
            return false
        }
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated( true, completion: nil )
    }
}
