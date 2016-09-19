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
            self.measure{
                self.waitForTest();
            }
        }
        else
        {
            waitForTest();
        }
    }
    
    fileprivate var testPerformance:Bool = true;
    
    fileprivate func waitForTest()
    {
//        pathFinderTest();
//        array2DTest();
//        priorityQueueTest();
        
        let s = S();
        var a = [0, 1, 3,5,5,6,7,9999,6,7,9999,1111,11,333,66,77,88,88,55,44,33,6,7,9999,6,7,9999,6,7,9999,6,7,9999];
        for i in 0...9999{
//            let _ = s.test1(a: i, b: &a);
            let _ = s.test2(a: i, b: a);
        }
        a.append(0);
        print(a.count);
    }
    
    
}


struct S {
    
    
    func test1(a: Int, b: inout [Int]) -> Int?{
        return b.index(of: a);
    }
    
    func test2(a: Int, b: [Int]) -> Int?{
        return b.index(of: a);
    }
}







