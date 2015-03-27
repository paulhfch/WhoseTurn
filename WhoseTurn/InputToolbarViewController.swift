//
//  InputToolBarViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class InputToolBarViewController: UIViewController {
    typealias Handler = ()->()
    var okayHandler: Handler?
    var cancelHandler: Handler?
    
    let xib = "InputToolBarViewController"

    override init() {
        super.init( nibName: xib, bundle: nil )
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        if let handler = cancelHandler {
            handler()
        }
    }
    
    @IBAction func onOkayButtonTapped(sender: AnyObject) {
        if let handler = okayHandler {
            handler()
        }
    }
}
