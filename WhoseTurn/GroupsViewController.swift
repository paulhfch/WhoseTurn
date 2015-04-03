//
//  GroupsViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

let groupCellIdentifier = "groupCell"
let showMemberSegueId = "showMembers"

class GroupsViewController : UITableViewController {
    var groups: [String]!
    
    func refresh() {
        var user = User.currentUser()
        user.fetch()
        
        groups = user.groups
        
        tableView.reloadData()
    }
    
    // MARK: UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showMemberSegueId {
            var destViewController = segue.destinationViewController as MembersViewController
            destViewController.groupName = sender as String
        }
    }
    
    // MAKR: Actions
    @IBAction func onLogoutButtonTapped(sender: AnyObject) {
        User.logOut()
        dismissViewControllerAnimated( true, completion: nil )
    }

    @IBAction func onAddButtonTapped(sender: AnyObject) {
        AddGroupDialog( parentViewController: self ).show()
    }
    
    @IBAction func onJoinButtonTapped(sender: AnyObject) {
        JoinGroupDialog( parentViewController: self ).show()
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        var cell = tableView.dequeueReusableCellWithIdentifier( groupCellIdentifier ) as GroupCell
        
        cell.groupNameLabel.text = groups[index]

        return cell;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groupArray = groups {
            return groups.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath( indexPath ) as GroupCell
        let groupName = cell.groupNameLabel.text
        
        performSegueWithIdentifier( showMemberSegueId, sender: groupName )
    }
    
    // http://stackoverflow.com/a/26338310
    // Customizes table row actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var leaveButton = UITableViewRowAction( style: .Default, title: "Leave Group", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        leaveButton.backgroundColor = UIColor.redColor()
        
        return [leaveButton]
    }
    
    // http://www.ioscreator.com/tutorials/delete-rows-table-view-ios8-swift
    // enables "swipe-to-delete"
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let groupName = self.groups[indexPath.row]
            
            var currentUser = User.currentUser()
            currentUser.groups.removeAtIndex( indexPath.row )
            self.groups.removeAtIndex( indexPath.row )
            tableView.deleteRowsAtIndexPaths( [indexPath], withRowAnimation: UITableViewRowAnimation.Automatic )
            
            currentUser.saveInBackgroundWithBlock({ (success: Bool, errro: NSError!) -> Void in
                if !success {
                    UIAlertView(title: "Cannot Leave Group \(groupName)",
                        message: "Are you connected to the Internet?",
                        delegate: nil,
                        cancelButtonTitle: "OK" ).show()
                }
            })  
        }
    }
}

class GroupCell : UITableViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
}
