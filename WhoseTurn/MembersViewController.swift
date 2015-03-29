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
    var payments: [String:[Payment]]?
    var members = [User]()
    var nextMemberToPay: String!
    
    @IBOutlet weak var navToolBar: UIToolbar!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        configureNavBar()
    }
    
    // Make sure to refetch data when the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        
        //MARK: TODO use promise?
        Group( name: group ).getMembers { (members) -> Void in
            self.members = members
            
            Payment.getPaymentsForEveryoneIn( self.group, callback: { ( payments: [String : [Payment]]) -> Void in
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
    private func getNextToPay( members: [User], _ payments: [String:[Payment]] ) -> String {
        // criteria is an array of ( member, numberOfPayments, latestPaymentDate )
        var criteria = [(String, Int, NSDate )]()
        
        for member in members {
            let memberName = member.username
            
            //MARK: unwrap multiple optionals - swift 1.2?
            if let paymentsOfMember = payments[memberName] {
                if let latestPayment = Payment.getLatestPaymentFrom( paymentsOfMember ){
                     criteria.append( ( memberName,
                        Payment.getNumberOfMembersPaidFor( paymentsOfMember ),
                        latestPayment.date ) )
                }
                else {
                    criteria.append( ( memberName,
                        Payment.getNumberOfMembersPaidFor( paymentsOfMember ),
                        NSDate( timeIntervalSince1970: 0 ) ) )
                }
            }
            else {
                criteria.append( ( memberName, 0, NSDate( timeIntervalSince1970: 0 ) ) )
            }
        }
        
        criteria.sort {
            let ( _, thisNumberOfPayments, thisLatestPaymentDate ) = $0
            let ( _, thatNumberOfPayments, thatLatestPaymentDate ) = $1
            
            if thisNumberOfPayments == thatNumberOfPayments {
                return thisLatestPaymentDate.compare( thatLatestPaymentDate ) == NSComparisonResult.OrderedAscending
            }
            
            return thisNumberOfPayments < thatNumberOfPayments
        }
        
        return criteria.first!.0 // return username of the member
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