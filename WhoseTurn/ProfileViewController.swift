//
//  ProfileViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

let showPaymentHistorySegueId = "showPaymentHistory"

class ProfileViewController : UITableViewController {
    var member: String!
    var group: String!
    var payments: [String:[Payment]]!
    
    @IBOutlet weak var lastPaymentLabel: UILabel!
    @IBOutlet weak var numberOfPaymentsLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateView()
    }
    
    private func configureNavBar() {
        self.title = member
    }
    
    private func updateView(){
        if let paymentOfMember = payments[member] {
            if let lastPayment = Payment.getLatestPaymentFrom( paymentOfMember ) {
                lastPaymentLabel.text = "\(DayFormatter.stringFromDate( lastPayment.date ))"
            }
            
            numberOfPaymentsLabel.text = "\(paymentOfMember.count)"
        }
        
        let owing = getMostCredits() - getCreditsOfMember( member )
        owingLabel.text = "\(owing)"
    }
    
    private func getMostCredits() -> Int {
        var credits = 0
        
        for ( member, paymentsOfMember ) in payments {
            let creditsOfMember = Payment.getNumberOfMembersPaidFor( paymentsOfMember )
            
            if creditsOfMember > credits {
                credits = creditsOfMember
            }
        }
        
        return credits
    }
    
    private func getCreditsOfMember( member: String ) -> Int {
        if let paymentsOfMember = payments[member] {
            return Payment.getNumberOfMembersPaidFor( paymentsOfMember )
        }
        else {
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showPaymentHistorySegueId {
            var destViewController = segue.destinationViewController as PaymentHistoryViewController
            
            destViewController.payments = payments[member]
        }
    }
}
