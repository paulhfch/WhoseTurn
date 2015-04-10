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
        static let paidFor = "paidFor"
    }
    
    // http://stackoverflow.com/a/24646298
    // Have to add @NSManaged to save to Parse
    @NSManaged var payor: String!
    @NSManaged var group: String!
    @NSManaged var restaurant: String!
    @NSManaged var date: NSDate!
    @NSManaged var paidFor: [String]!
    
    class func parseClassName() -> String {
        return "Payment"
    }
    
    // MARK: Utils
    class func getPaymentsForEveryoneInGroup( group: String, callback: ([Payment]) -> Void ) {
        let query = Payment.query()
        query!.whereKey( Payment.ColumnKey.group, equalTo: group )
        
        query!.findObjectsInBackgroundWithBlock { (payments: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                callback( payments as! [Payment] )
            }
            else {
                callback( [Payment]() )
            }
        }
    }
    
    class func getPaymentsOfMember( member: String, payments: [Payment] ) -> [Payment] {
        return payments.filter { $0.payor == member }
    }
    
    class func getLatestPaymentForMember( member: String, payments: [Payment] ) -> Payment? {
        var entries = payments.filter { $0.payor == member }
        
        entries.sort { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending }
        
        return entries.first
    }
    
    class func getCreditsForMember( member: String, payments: [Payment] ) -> Int {
        var credits = 0
        
        for payment in payments {
            if payment.payor == member {
                credits += payment.paidFor.count
            }
            else {
                credits += payment.paidFor.reduce( 0 ) {
                    if $1 == member {
                        return $0 - 1
                    }
                    
                    return $0
                }
            }
        }
        
        return credits
    }
}