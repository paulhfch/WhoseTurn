//
//  Group.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class Group {
    var name : String
    
    init( name : String ){
        self.name = name
    }
    
    func getMembers( callback : ( members: [User]! ) -> Void ) {
        let query = User.query()
        query.whereKey( User.ColumnKey.groups, equalTo: name )
        
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