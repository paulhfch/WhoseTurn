//
//  JoinGroupDialog.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-04-02.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit


class JoinGroupDialog {
    
    weak var parentViewController: GroupsViewController?
    var dialog: UIAlertController!
    
    var hasGroupName = false
    var hasGroupCode = false
    
    init( parentViewController: GroupsViewController ) {
        self.parentViewController = parentViewController
        
        dialog = UIAlertController(title: "Join an existing Group",
            message: nil,
            preferredStyle: UIAlertControllerStyle.Alert )
        
        var joinAction = UIAlertAction(title: "Join",
            style: UIAlertActionStyle.Default) {
                (_) in
                
                let groupNameText = self.dialog.textFields![0] as UITextField
                let groupCodeText = self.dialog.textFields![1] as UITextField
                let groupName = groupNameText.text
                let groupCode = groupCodeText.text
                
                if self.validGroupInfo( groupName, groupCode ){
                    let currentUser = User.currentUser() as User
                    if  currentUser.groups == nil {
                        currentUser.groups = [ groupName ]
                    }
                    else {
                        if !contains( currentUser.groups, groupName ){
                            currentUser.groups.append( groupName )
                        }
                    }
                    
                    currentUser.save()
                    
                    self.parentViewController?.refresh()
                }
                else {
                    UIAlertView(title: "Cannot Join Group \(groupName)",
                        message: "Group does not exist or group name does not match group code.",
                        delegate: nil,
                        cancelButtonTitle: "Try Again" ).show()
                }
        }
        joinAction.enabled = false
        
        var cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel) { (_) in }
        
        dialog.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Group Name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
                object: textField,
                queue: NSOperationQueue.mainQueue()) { (notification) in
                    self.hasGroupName = textField.text != ""
                    joinAction.enabled = self.hasGroupName && self.hasGroupCode
            }
        }
        
        dialog.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Group Code"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
                object: textField,
                queue: NSOperationQueue.mainQueue()) { (notification) in
                    self.hasGroupCode = textField.text != ""
                    joinAction.enabled = self.hasGroupName && self.hasGroupCode
            }
        }
        
        dialog.addAction( cancelAction )
        dialog.addAction( joinAction )
    }
    
    private func validGroupInfo( groupName: String, _ groupCode: String ) -> Bool {
        if groupName == "" || groupCode == "" {
            return false
        }

        if let group = Group.getGroupWithName( groupName ) {
            let expectedCode = VerificationCode( from: group ).code
            return expectedCode == groupCode
        }
        else {
            return false
        }
    }
    
    func show() {
        parentViewController?.presentViewController( dialog, animated: true, completion: nil)
    }
}
