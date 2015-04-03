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
    
    var payments: [Payment]?
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if payments != nil {
            payments!.sort { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending }
        }
    }
    
    // MARK: UITableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let paymentRecords = payments {
            return paymentRecords.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier( cellIdentifier ) as PaymentHistoryCell
        
        if let paymentRecords = payments {
            let payment = paymentRecords[indexPath.row]
            cell.restaurantLabel.text = payment.restaurant
            cell.dateLabel.text = DayFormatter.stringFromDate( payment.date )
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let payment = self.payments![indexPath.row]
            payment.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                if success {
                    self.payments!.removeAtIndex( indexPath.row )
                    tableView.deleteRowsAtIndexPaths( [indexPath], withRowAnimation: UITableViewRowAnimation.Automatic )
                }
            })
        }
    }
}

class PaymentHistoryCell: UITableViewCell {
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
