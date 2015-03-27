//
//  Payment.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class Payment : PFObject, PFSubclassing {
    
    var payor: String!
    var group: String!
    var restaurant: String!
    var date: NSDate!
    
    class func parseClassName() -> String! {
        return "Payment"
    }
}