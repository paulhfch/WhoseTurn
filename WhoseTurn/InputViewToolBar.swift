//
//  InputViewToolBar.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-30.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class InputViewToolBar: UIToolbar {
    
    weak var parentViewController: UIViewController!
    var doneHandler: (()->Void )?

     init( parentViewController: UIViewController ){
        self.parentViewController = parentViewController

        super.init(frame: CGRectMake( 0, 0, 200, 50 ) )
        
        let cancelButton = UIBarButtonItem( barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "onCancelButtonTapped" )
        let doneButton = UIBarButtonItem( barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "onDoneButtonTapped" )
        
        let flexibleSpace = UIBarButtonItem( barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil )
        
        self.setItems( [cancelButton, flexibleSpace, doneButton], animated: true )
    }

    // Not going to load it from Storyboard
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc private func onCancelButtonTapped() {
        dismissInputView()
    }
    
    @objc private func onDoneButtonTapped() {
        if let handler = doneHandler {
            handler()
        }
        
        dismissInputView()
    }
    
    private func dismissInputView() {
        parentViewController.view.endEditing( true )
    }
}
