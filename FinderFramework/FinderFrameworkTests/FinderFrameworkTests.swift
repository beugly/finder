//
//  FinderFrameworkTests.swift
//  FinderFrameworkTests
//
//  Created by 叶贤辉 on 16/1/9.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import XCTest
@testable import FinderFramework

class FinderFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFramework()
    {
        if testPerformance
        {
            self.measureBlock{
                self.waitForTest();
            }
        }
        else
        {
            waitForTest();
        }
    }
    
    private var testPerformance:Bool = false;
    
    private func waitForTest()
    {
//        pathFinderTest();
//        array2DTest();
        priorityQueueTest();
    }
    
    
}








