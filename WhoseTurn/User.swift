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

}