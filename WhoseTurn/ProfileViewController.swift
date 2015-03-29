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
    var payments: [Payment]!
    
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
        if let lastPayment = Payment.getLatestPaymentFor( member, payments: payments ) {
            lastPaymentLabel.text = "\(DayFormatter.stringFromDate( lastPayment.date ))"
        }
        
        let paymentOfMember = Payment.getPaymentsOfMember( self.member, payments: self.payments )
        numberOfPaymentsLabel.text = "\(paymentOfMember.count)"
        
        
        let owing = abs( min( 0, Payment.getCreditsFor( self.member, payments: self.payments ) ) )
        owingLabel.text = "\(owing)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showPaymentHistorySegueId {
            var destViewController = segue.destinationViewController as PaymentHistoryViewController
            
            destViewController.payments = Payment.getPaymentsOfMember( self.member, payments: self.payments )
        }
    }
}
