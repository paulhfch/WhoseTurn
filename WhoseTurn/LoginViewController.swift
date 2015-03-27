//
//  ViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-24.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

let showGroupsSegueId = "showGroups"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextbox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextbox.delegate = self
        passwordTextBox.delegate = self
    }

    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(
            usernameTextbox.text,
            password: passwordTextBox.text) { ( user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    self.performSegueWithIdentifier( showGroupsSegueId, sender: nil )
                }
                else {
                    UIAlertView(title: "Login Failed",
                        message: "Incorrect Username/Password combination (Are you connected to the Internet?)",
                        delegate: nil,
                        cancelButtonTitle: "Try again" ).show()
                }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
        onLoginButtonTapped( textField )
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showGroupsSegueId {
            let user = PFUser.currentUser() as User
            
            // segues to GroupsViweController via NavigationViewController
            var destViewController = segue.destinationViewController.viewControllers![0] as GroupsViewController
            destViewController.groups = user.getGroups()
        }
    }
}

