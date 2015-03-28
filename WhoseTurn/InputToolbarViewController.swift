//
//  InputToolBarViewController.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class InputToolBarViewController: UIViewController {
    
    let xib = "InputToolBarViewController"

    typealias Handler = ()->()
    var okayHandler: Handler?
    var cancelHandler: Handler?
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        let view = NSBundle.mainBundle().loadNibNamed( xib, owner: self, options: nil).first as UIView
//        view.addSubview( view )
//    }
    
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
