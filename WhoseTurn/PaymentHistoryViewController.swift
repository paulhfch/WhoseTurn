//
//  PaymentHistoryViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-28.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: UITableViewController {
    
    let cellIdentifier = "paymentHistoryCell"
    
    var payments : [Payment]!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payments.sort { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending }
    }
    
    // MARK: UITableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let payment = payments[indexPath.row]
        
        var cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier ) as PaymentHistoryCell
        
        cell.restaurantLabel.text = payment.restaurant
        cell.dateLabel.text = DayFormatter.stringFromDate( payment.date )
        
        return cell
    }
}

class PaymentHistoryCell: UITableViewCell {
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
