//
//  DayFormatter.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import Foundation

class DayFormatter {
    
    class func getFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy EEE"
        
        return formatter
    }
    
    class func stringFromDate( date: NSDate ) -> String {
        return getFormatter().stringFromDate( date )
    }
    
    class func dateFromString( dateString: String ) -> NSDate {
        return getFormatter().dateFromString( dateString )!
    }
}