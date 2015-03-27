//
//  User.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

let userClass = "User"
let groupColumnKey = "groups"

class User : PFUser {
    
    class func register() {
        registerSubclass()
    }
    
    func getGroups() -> [String]! {
        return objectForKey( groupColumnKey ) as [String]!
    }
}