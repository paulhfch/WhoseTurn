//
//  GroupTests.swift
//  WhoseTurn
//
//  Created by Fangchen Huang on 2015-04-04.
//  Copyright (c) 2015 PopoWorks. All rights reserved.
//

import UIKit
import XCTest

class GroupTests: XCTestCase {
    
    var members: [User]!
    var member1: User!
    var member2: User!
    
    override func setUp() {
        super.setUp()
        
        // required by Parse
        Parse.setApplicationId( "test", clientKey: "test" )
        
        User.registerSubclass()
        Payment.registerSubclass()
        
        member1 = User()
        member2 = User()
        member1.username = "member1"
        member2.username = "member2"
        
        members = [member1, member2]
    }
 

    func testGroupUtils_getNextToPay_memberWhoOwesTheMostShouldPay() {
        // member1 paid for member2 twice;         
        let memberOnePaid = Payment()
        memberOnePaid.payor = member1.username
        memberOnePaid.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        memberOnePaid.paidFor = [member2.username!]
        
        let memberOnePaidAgain = Payment()
        memberOnePaidAgain.payor = member1.username
        memberOnePaidAgain.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        memberOnePaidAgain.paidFor = [member2.username!]
        
        // member2 paid once
        let memberTwoPaid = Payment()
        memberTwoPaid.payor = member2.username
        memberTwoPaid.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        memberTwoPaid.paidFor = [member1.username!]
        
        let payments = [memberOnePaid, memberOnePaidAgain, memberTwoPaid]
        
        XCTAssertEqual( Group.getNextToPay( members, payments ),
            member2.username!,
            "Member 2 should pay next" )
    }
    
    func testGroupUtils_getNextToPay_memberWhoNeverPaidShouldPay() {
        // member1 paid for member2; member2 hasn't paid
        let payment = Payment()
        payment.payor = member1.username
        payment.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        payment.paidFor = [member2.username!]
        
        XCTAssertEqual( Group.getNextToPay( members, [payment] ),
            member2.username!,
            "Member 2 should pay next" )
    }
    
    func testGroupUtils_getNextToPay_memberWhoPaidEarlierShouldPay() {
        // member1 paid for member2
        let memberOnePaid = Payment()
        memberOnePaid.payor = member1.username
        memberOnePaid.date = DayFormatter.dateFromString( "Jan 02, 2000 Tue" )
        memberOnePaid.paidFor = [member2.username!]
        
        // member2 paid too, but earlier than last time member1 paid
        let memberTwoPaid = Payment()
        memberTwoPaid.payor = member2.username
        memberTwoPaid.date = DayFormatter.dateFromString( "Jan 01, 2000 Mon" )
        memberTwoPaid.paidFor = [member1.username!]
        
        let payments = [memberOnePaid, memberTwoPaid]
        
        XCTAssertEqual( Group.getNextToPay( members, payments ),
            member2.username!,
            "Member 2 should pay next" )
    }
}
