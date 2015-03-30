//
//  PayorPickerView.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

class PayorPickerViewController : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let payors: [User]
    weak var parentViewController: UIViewController!
    
    init( payors: [User] ){
        self.payors = payors
        
        super.init( frame: CGRectMake( 0, 0, 100, 50 ) )
        self.dataSource = self
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSelectedPayor() -> String {
        let index = self.selectedRowInComponent( 0 )
        
        return payors[index].username
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payors.count
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return payors[row].username
    }
}