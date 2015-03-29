//
//  MemberMultipleSelectionViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-28.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class MemberMultipleSelectionViewController: UITableViewController {
    
    let cellIdentifier = "memberMultileSelectionCell"
    
    var payor: String!
    var members: [User]!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update( self.payor, self.members )
    }
    
    func update( payor: String, _ members: [User]! ){
        var otherMembers = [User]()
        
        for member in members {
            if member.username != payor {
                otherMembers.append( member )
            }
        }
        
        self.members = otherMembers
        
        tableView.reloadData()
    }
    
    func getSelectedMembers() -> [String] {
        var selectedMembers = [String]()
        
        for cell in tableView.visibleCells() as [MemberMultileSelectionCell] {
            if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                selectedMembers.append( cell.memberNameLabel.text! )
            }
        }
        
        return selectedMembers
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier ) as MemberMultileSelectionCell

        cell.memberNameLabel.text = members[indexPath.row].username
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath( indexPath ) as MemberMultileSelectionCell
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }

}

class MemberMultileSelectionCell : UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
}
