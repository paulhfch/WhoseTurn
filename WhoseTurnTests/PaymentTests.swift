//
//  WhoseTurnTests.swift
//  WhoseTurnTests
//
//  Created by Fangchen Huang on 2015-03-24.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit
import XCTest

class PaymentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Payment.registerSubclass() // required by Parse SDK
    }
    
    func testPaymentUtils_shouldReturnLatestPayment() {
        let payor = "Payor"
        
        let payment1 = Payment()
        payment1.payor = payor
        payment1.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        
        let payment2 = Payment()
        payment2.payor = payor
        payment2.date = DayFormatter.dateFromString( "Jan 02, 2000 Tue" )
        
        let latestPayment = Payment()
        latestPayment.payor = payor
        latestPayment.date = DayFormatter.dateFromString( "Jan 03, 2000 Wed" )
        
        let actual = Payment.getLatestPaymentForMember( payor, payments: [payment1, payment2, latestPayment])
        
        XCTAssertEqual( actual!, latestPayment, "Should return the latest payment" )
    }
    
    func testPaymentUtils_shouldCalculateCreditForMember() {
        let member = "member"
    
        // Paid for 2 other members, gets 2 credits
        let payment1 = Payment()
        payment1.payor = member
        payment1.paidFor = [ "otherMember1", "otherMember2" ]
        
        // Was paid for once, deducts 1 credit
        let payment2 = Payment()
        payment2.payor = "otherMember1"
        payment2.paidFor = [ member ]
        
        let credits = Payment.getCreditsForMember( member, payments: [payment1, payment2] )
        
        XCTAssertEqual( credits, 1, "Should return 1 credit as a result" )
    }
    
}
