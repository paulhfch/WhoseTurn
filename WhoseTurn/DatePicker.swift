//
//  DatePicker.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-03-27.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit

// Has to subclass NSObject; otherwise error occurs: "unrecognized selector onDateChanged"
class DatePicker: NSObject {
    var view: UIDatePicker
    weak var textField: UITextField?

    init( textField: UITextField ){
        self.textField = textField
        
        self.view = UIDatePicker()
        self.view.datePickerMode = UIDatePickerMode.Date
        
        super.init()
        
        self.view.addTarget( self, action: "onDateChanged:", forControlEvents: UIControlEvents.ValueChanged )
    }
    
    @objc private func onDateChanged( datePicker: UIDatePicker ){
        let date = datePicker.date
        
        textField?.text = DayFormatter.stringFromDate( date )
    }
    
}
