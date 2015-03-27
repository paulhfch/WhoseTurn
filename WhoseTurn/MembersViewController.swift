//
//  MembersViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

let memberCellIdentifier = "memberCell"
let showProfileSegueId = "showProfile"

class MembersViewController : UITableViewController {
    var groupName : String!
    var members : [User]!
    
    @IBOutlet weak var navToolBar: UIToolbar!
    
    override func viewDidLoad() {
        configureNavBar()
        
        Group( name: groupName ).getMembers { (members) -> Void in
            self.members = members
            
            self.tableView.reloadData()
            
            // MARK: TODO determine who's next to pay
        }
    }
    
    private func configureNavBar() {
        self.title = groupName

        // http://stackoverflow.com/a/14448645
        // Removes UIToolBar top border line
        navToolBar.clipsToBounds = true
    }
    
    @IBAction func onAddPaymentRecordButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func onAddMemberButtonTapped(sender: AnyObject) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memberArray = members {
            return memberArray.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        var cell = tableView.dequeueReusableCellWithIdentifier( memberCellIdentifier ) as MemberCell
        
        cell.memberNameLabel.text = members[index].username
        cell.nextToPayLabel.hidden = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath( indexPath ) as MemberCell
        
        performSegueWithIdentifier( showProfileSegueId, sender: cell.memberNameLabel.text )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showProfileSegueId {
            var destViewController = segue.destinationViewController as ProfileViewController
            
            destViewController.memberName = sender as String
        }
    }
}

class MemberCell : UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var nextToPayLabel: UILabel!
}