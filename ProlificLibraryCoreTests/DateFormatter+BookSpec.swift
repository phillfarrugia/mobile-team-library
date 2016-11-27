//
//  ProlificLibraryCoreTests.swift
//  ProlificLibraryCoreTests
//
//  Created by Phill Farrugia on 27/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Quick
import Nimble
import ProlificLibraryCore

class DateFormatterBookSpec: QuickSpec {
    override func spec() {
        
        describe("format lastCheckedOutDate", {
            
            it("should return correct string format", closure: {
                let sampleDateOne = Date(timeIntervalSince1970: 1308031456)
                expect(DateFormatter.format(lastCheckedOutDate: sampleDateOne)).to(equal("June 14, 2011 4:04 PM"))
                
                let sampleDateTwo = Date(timeIntervalSince1970: 1480214114)
                expect(DateFormatter.format(lastCheckedOutDate: sampleDateTwo)).to(equal("November 27, 2016 1:35 PM"))
                
                let sampleDateThree = Date(timeIntervalSince1970: 1258684398)
                expect(DateFormatter.format(lastCheckedOutDate: sampleDateThree)).to(equal("November 20, 2009 1:33 PM"))
            })
            
        })
        
    }
}
