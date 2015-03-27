//
//  ProfileViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-26.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class ProfileViewController : UITableViewController {
    var memberName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.title = memberName
    }
}
