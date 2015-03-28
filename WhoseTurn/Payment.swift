//
//  Payment.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class Payment : PFObject, PFSubclassing {
    
    struct ColumnKey {
        static let payor = "payor"
        static let group = "group"
    }
    
    // http://stackoverflow.com/a/24646298
    // Have to add @NSManaged to save to Parse
    @NSManaged var payor: String!
    @NSManaged var group: String!
    @NSManaged var restaurant: String!
    @NSManaged var date: NSDate!
    
    class func parseClassName() -> String! {
        return "Payment"
    }
    
    class func getPaymentsFor( username: String, group: String, callback: ([Payment]) -> Void ) {
        let query = Payment.query()
        
        query.whereKey( Payment.ColumnKey.payor, equalTo: username )
        query.whereKey( Payment.ColumnKey.group, equalTo: group )
        
        query.findObjectsInBackgroundWithBlock { ( payments: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                callback( payments as [Payment]! )
            }
            else {
                callback( [Payment]() )
            }
        }
    }
    
    /**
        Retrieves all payments in a group in the format of [ member: [payments] ]
    */
    class func getPaymentsForEveryoneIn( group: String, callback: ([String:[Payment]]) -> Void ) {
        let query = Payment.query()
        query.whereKey( Payment.ColumnKey.group, equalTo: group )
        
        query.findObjectsInBackgroundWithBlock { ( payments: [AnyObject]!, error: NSError!) -> Void in
            var paymentsMap = [String:[Payment]]()
            
            if error == nil {
                for payment in payments as [Payment] {
                    let memberName = payment.payor
                    
                    if paymentsMap[memberName] == nil {
                        paymentsMap[memberName] = [ payment ]
                    }
                    else {
                        paymentsMap[memberName]!.append( payment )
                    }
                }
                
                callback( paymentsMap )
            }
            else {
                callback( paymentsMap )
            }
        }
    }
    
    class func getLatestPaymentFrom( payments: [Payment] ) -> Payment? {
        var entries = payments
        
        entries.sort { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending }
        
        return entries.first
    }
}