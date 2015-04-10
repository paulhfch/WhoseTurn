//
//  Settings.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-04-01.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

private let settings = Settings()

class Settings {
    
    private struct Constants {
        static let SettingsPlistFilename = "Settings"
        static let ParseAppId = "ParseAppId"
        static let ParseClientKey = "ParseClientKey"
    }
    
    class var sharedInstance : Settings {
        return settings
    }

    var parseAppId: String!
    var parseClientKey: String!
    
    init() {
        var settingsPlist: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource( "Settings", ofType: "plist" ) {
            settingsPlist = NSDictionary( contentsOfFile: path )
        }
        else {
            fatalError( "Please provide a Settings.plist file" )
        }
        
        if let plist = settingsPlist {
            parseAppId = plist[Constants.ParseAppId] as! String
            parseClientKey = plist[Constants.ParseClientKey] as! String
        }
    }
}