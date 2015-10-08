//
//  swiftracerTests.swift
//  swiftracerTests
//
//  Created by Khrob Edmonds on 6/10/2015.
//  Copyright © 2015 khrob. All rights reserved.
//

import XCTest
@testable import swiftracer

class swiftracerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDotProduct ()
    {
        let v1 = Vector(x: 1.0, y:0.0, z:1.0)
        let v2 = Vector(x: 1.0, y:1.0, z:1.0)
        
        let dotproduct = v1 ∙ v2
        XCTAssert(dotproduct == 2, "Works!")
    }
}
