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
    
    init( from string: String ){
        let hashInHex = NSString( format:"%2X", string.hash )
        code = hashInHex.substringWithRange( NSMakeRange( 1,  4 ) )
    }
}
