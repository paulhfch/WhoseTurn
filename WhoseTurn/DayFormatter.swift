//
//  DayFormatter.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class DayFormatter {
    
    class func stringFromDate( date: NSDate ) -> String {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate( "yyyy-MMM-dd EEEE" )
        
        return formatter.stringFromDate( date )
    }
}