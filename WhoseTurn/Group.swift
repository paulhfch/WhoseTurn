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
}