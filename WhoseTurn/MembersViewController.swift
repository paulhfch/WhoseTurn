//
//  MembersViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

let memberCellIdentifier = "memberCell"

class MembersViewController : UITableViewController {
    var groupName : String!
    var members : [User]!
    
    override func viewDidLoad() {
        self.title = groupName
        
        Group( name: groupName ).getMembers { (members) -> Void in
            self.members = members
            
            self.tableView.reloadData()
        }
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
        
        return cell
    }
}

class MemberCell : UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
}