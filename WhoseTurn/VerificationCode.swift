//
//  VerificationCode.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-31.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class VerificationCode {
    
    let code: String
    
    init( from group: Group ){
        let objectId = group.objectId as NSString
        code = objectId.substringWithRange( NSMakeRange( 1,  4 ) ).uppercaseString
    }
}
