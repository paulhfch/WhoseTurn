//
//  MembersViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

let showProfileSegueId = "showProfile"
let showNewPaymentSegueId = "showNewPayment"

class MembersViewController : UITableViewController {
    
    let cellIdentifier = "memberCell"
    
    var groupName: String!
    var payments: [Payment]?
    var members = [User]()
    var nextMemberToPay: String!
    
    @IBOutlet weak var verificationCodeLabel: UILabel!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        configureNavBar()
        
        displayVerificationCode()
    }
    
    private func configureNavBar() {
        self.title = groupName
    }
    
    private func displayVerificationCode() {
        Group.getGroupWithNameAsync( groupName, callback: { group in
            let code = VerificationCode( from: group! ).code
            self.verificationCodeLabel.text = "Group Code: \(code)"
        })
    }
    
    // Make sure to refetch data when the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        
        User.getMembersInGroup ( groupName ) { (members) -> Void in
            self.members = members
            
            Payment.getPaymentsForEveryoneIn( self.groupName, callback: { ( payments: [Payment]) -> Void in
                self.payments = payments
                self.nextMemberToPay = Group.getNextToPay( members, payments )
                
                self.tableView.reloadData()
            })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showProfileSegueId {
            var destViewController = segue.destinationViewController as ProfileViewController
            
            destViewController.member = sender as String
            destViewController.group = groupName
            destViewController.payments = payments
            destViewController.members = members
        }
        
        if segue.identifier == showNewPaymentSegueId {
            var destViewController = segue.destinationViewController as NewPaymentViewController
            
            destViewController.group = groupName
            destViewController.members = members
        }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.row
        var cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier ) as MemberCell
        
        let memberName = members[index].username
        
        cell.memberNameLabel.text = memberName
        cell.nextToPayLabel.hidden = memberName != self.nextMemberToPay
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath( indexPath ) as MemberCell
        
        performSegueWithIdentifier( showProfileSegueId, sender: cell.memberNameLabel.text )
    }
}

class MemberCell : UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var nextToPayLabel: UILabel!
}