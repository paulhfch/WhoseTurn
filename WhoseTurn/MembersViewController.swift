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
    
    var group: String!
    var payments: [Payment]?
    var members = [User]()
    var nextMemberToPay: String!
    
    @IBOutlet weak var navToolBar: UIToolbar!
    @IBOutlet weak var verificationCodeLabel: UILabel!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        configureNavBar()
        
        displayVerificationCode()
    }
    
    private func displayVerificationCode() {
        let code = VerificationCode( from: group ).code
        verificationCodeLabel.text = "Group Code: \(code)"
    }
    
    // Make sure to refetch data when the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        
        //MARK: TODO use promise?
        Group( name: group ).getMembers { (members) -> Void in
            self.members = members
            
            Payment.getPaymentsForEveryoneIn( self.group, callback: { ( payments: [Payment]) -> Void in
                self.payments = payments
                self.nextMemberToPay = self.getNextToPay( members, payments )
                
                self.tableView.reloadData()
            })
        }
    }
    
    private func configureNavBar() {
        self.title = group

        // http://stackoverflow.com/a/14448645
        // Removes UIToolBar top border line
        navToolBar.clipsToBounds = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showProfileSegueId {
            var destViewController = segue.destinationViewController as ProfileViewController
            
            destViewController.member = sender as String
            destViewController.group = group
            destViewController.payments = payments
        }
        
        if segue.identifier == showNewPaymentSegueId {
            var destViewController = segue.destinationViewController as NewPaymentViewController
            
            destViewController.group = group
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
    
    /**
        The member who owes the most and hasn't paid lately is the next to pay
    */
    private func getNextToPay( members: [User], _ payments: [Payment] ) -> String {
        // ( member, numberOfPayments, latestPaymentDate )
        typealias Criterion = (String, Int, NSDate )
        
        var criteria = [Criterion]()
        
        for member in members {
            let memberName = member.username
            var criterion: Criterion
            
            if let latestPayment = Payment.getLatestPaymentFor( memberName, payments: payments ){
                
                criterion = (
                    memberName,
                    Payment.getCreditsFor( memberName, payments: payments ),
                    latestPayment.date
                )
            }
            else { // If no payment record is found, crafts a criterion which makes this member pay next
                criterion = (
                    memberName,
                    Int.min,
                    NSDate( timeIntervalSince1970: 0 )
                )
            }
            
            criteria.append( criterion )
        }
        
        criteria.sort {
            let ( _, thisCredits, thisLatestPaymentDate ) = $0
            let ( _, thatCredits, thatLatestPaymentDate ) = $1
            
            if thisCredits == thatCredits {
                return thisLatestPaymentDate.compare( thatLatestPaymentDate ) == NSComparisonResult.OrderedAscending
            }
            
            return thisCredits < thatCredits
        }
        
        return criteria.first!.0 // return username of the first member
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