//
//  User.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class User : PFUser, PFSubclassing {
    
    struct ColumnKey {
        static let groups = "groups"
    }
    
    @NSManaged var groups: [String]!

    class func getMembersInGroup( group: String, callback : ( members: [User]! ) -> Void ) {
        let query = User.query()
        query.whereKey( User.ColumnKey.groups, equalTo: group )
        
        query.findObjectsInBackgroundWithBlock { ( members: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                callback( members: members as [User]! )
            }
            else {
                callback( members: nil )
            }
        }
    }
}