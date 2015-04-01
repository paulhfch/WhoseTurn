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
    
    @IBAction func onLogoutButtonTapped(sender: AnyObject) {
        User.logOut()
        dismissViewControllerAnimated( true, completion: nil )
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showMemberSegueId {
            var destViewController = segue.destinationViewController as MembersViewController
            destViewController.groupName = sender as String
        }
    }
}

class GroupCell : UITableViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
}
