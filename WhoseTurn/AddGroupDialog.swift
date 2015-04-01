//
//  AddGroupDialog.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-04-01.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class AddGroupDialog {
    
    weak var parentViewController: GroupsViewController?
    var dialog: UIAlertController!
    
    init( parentViewController: GroupsViewController ) {
        self.parentViewController = parentViewController
        
        dialog = UIAlertController(title: "Create a Group",
            message: nil,
            preferredStyle: UIAlertControllerStyle.Alert )
        
        var addAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default) {
                (_) in
                let groupTextField = self.dialog.textFields![0] as UITextField
                let groupName = groupTextField.text
                
                if let group = Group.getGroupWithName( groupName ) {
                    UIAlertView(title: "Create A Group",
                        message: "Group \"\(groupName)\" already exists",
                        delegate: nil,
                        cancelButtonTitle: "OK" ).show()
                }
                else {
                    let currentUser = User.currentUser() as User
                    if  currentUser.groups == nil {
                        currentUser.groups = [String]()
                    }
                        
                    currentUser.groups.append( groupName )
                    currentUser.save()
                    
                    let newGroup = Group()
                    newGroup.name = groupName
                    newGroup.save()
                    
                    self.parentViewController?.refresh()
                }
        }
        addAction.enabled = false
        
        var cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel) { (_) in }
        
        dialog.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Group Name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
                object: textField,
                queue: NSOperationQueue.mainQueue()) { (notification) in
                    addAction.enabled = textField.text != ""
            }
        }
        
        dialog.addAction( cancelAction )
        dialog.addAction( addAction )
    }
    
    func show() {
        parentViewController?.presentViewController( dialog, animated: true, completion: nil)
    }
}
