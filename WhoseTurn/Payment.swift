//
//  Payment.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class Payment : PFObject, PFSubclassing {
    
    // http://stackoverflow.com/a/24646298
    // Have to use @NSManaged to save to Parse
    @NSManaged var payor: String!
    @NSManaged var group: String!
    @NSManaged var restaurant: String!
    @NSManaged var date: NSDate!
    
    class func parseClassName() -> String! {
        return "Payment"
    }
}