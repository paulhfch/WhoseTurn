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
    weak var textField: UITextField?
    
    init( payors: [User], textField: UITextField ){
        self.payors = payors
        self.textField = textField
        
        super.init( frame: CGRectMake( 0, 0, 100, 50 ) )
        self.dataSource = self
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = payors[row].username
    }
}