//
//  Group.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class Group : PFObject, PFSubclassing {
    
    struct ColumnKey {
        static let name = "name"
    }
    
    @NSManaged var name : String!
    
    class func parseClassName() -> String! {
        return "Group"
    }
    
    class func getGroupWithNameAsync( name : String, callback: Group? -> Void ) {
        let query = Group.query()
        query.whereKey( Group.ColumnKey.name, equalTo: name )
        
        query.findObjectsInBackgroundWithBlock { ( groups: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                callback( groups.first as Group? )
            }
        }
    }
    
    class func getGroupWithName( name: String ) -> Group? {
        let query = Group.query()
        query.whereKey( Group.ColumnKey.name, equalTo: name )
     
        return query.findObjects().first as Group?
    }
    
    /**
    The member who owes the most and hasn't paid lately is the next to pay
    */
    class func getNextToPay( members: [User], _ payments: [Payment] ) -> String {
        // ( member, numberOfPayments, latestPaymentDate )
        typealias Criterion = ( String, Int, NSDate )
        
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
}