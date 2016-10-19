//
//  PriorityQueueTest.swift
//  X_Framework
//
//  Created by 173 on 15/12/18.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation
@testable
import FinderFramework;






typealias PQ = PriorityQueue<Int>;

let testType: PQTestType = .normal;


private func testNormal(){
    var queue = PQ.init(minimum: 2)
//    var queue = PQ.heap(maximum: []);
    var count = 4000;
    let i = count;
    repeat{
        queue.enqueue(count);
        count -= 1;
    }while count > 0;
    var a = 0;
    repeat{
        let e = queue.dequeue()!;
//        print("current:", e, "last:", a, "current-last=", e - a);
        a = e;
    }
        while !queue.isEmpty
    print("insert: \(i) popBest: \(i)" , a);
}


private func testBuild(){
    var sortArray:[Int] = [];
    
    for _ in 0...100
    {
        sortArray.append(Int(arc4random()));
    }
    var queue = PQ.init(minimum: 2)
    queue.build(sortArray);
    sortArray.sort(by: {$0 > $1})
    while !queue.isEmpty {
        let e1 = queue.dequeue()!;
        let e2 = sortArray.removeLast();
        print("\(e1)-\(e2)=\(e1 - e2)  count:\(queue.count)");
    }
}


private func testReplace(){
    let arr = [0, 2, 3, 1, 9, 6, 8, 7];
    var queue = PQ.init(minimum: 2)
    queue.build(arr);
    print(queue.elements);
    queue.update(-1, at: queue.index(of: 9)!);
    print(queue.elements);
    while !queue.isEmpty
    {
        let e1 = queue.dequeue()!;
        print(e1);
    }

}


//XPriorityQueue test
func priorityQueueTest()
{
    switch testType {
    case .build:
        testBuild();
    case .replace:
        testReplace();
    default:
        testNormal();
    }
}

enum PQTestType{
    case build, replace, normal
}
