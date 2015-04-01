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
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextbox.delegate = self
        passwordTextBox.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear( animated )
        
        self.enableControls( true )
        
        let currentUser = PFUser.currentUser()
        // http://stackoverflow.com/a/12320222
        // The modal view is not in the window's view hierarchy at viewDidLoad
        if currentUser != nil && currentUser.isAuthenticated() {
            performSegueWithIdentifier( showGroupsSegueId, sender: self )
        }
    }

    // MARK: Actions
    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        enableControls( false )
        
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
                    
                    self.enableControls( true )
                }
        }
    }
    
    private func enableControls( enabled : Bool ) {
        usernameTextbox.userInteractionEnabled = enabled
        passwordTextBox.userInteractionEnabled = enabled
        loginButton.userInteractionEnabled = enabled
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
        onLoginButtonTapped( textField )
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showGroupsSegueId {
            let user = User.currentUser() as User
            
            // segues to GroupsViweController via NavigationViewController
            var destViewController = segue.destinationViewController.viewControllers![0] as GroupsViewController
            destViewController.groups = user.groups
        }
    }
}

