//
//  ProfileViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class ProfileViewController : UITableViewController {
    var member: String!
    var group: String!
    var payments: [Payment]!
    
    @IBOutlet weak var lastPaymentLabel: UILabel!
    @IBOutlet weak var numberOfPaymentsLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        fetchPaymentRecords()
    }
    
    private func configureNavBar() {
        self.title = member
    }
    
    private func fetchPaymentRecords() {
        Payment.getPaymentsFor( member, group: group) { ( payments:[Payment]) -> Void in
            self.payments = payments
            
            self.updateView()
        }
    }
    
    private func updateView(){
        if let lastPayment = Payment.getLatestPaymentFrom( payments ) {
            lastPaymentLabel.text = "\(DayFormatter.stringFromDate( lastPayment.date ))"
        }
        
        numberOfPaymentsLabel.text = "\(payments.count)"
    }
}
