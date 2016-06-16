//: Playground - noun: a place where people can play

import UIKit
import SpriteKit;




//let p = UnsafeMutablePointer<String>.alloc(1);
//p.initialize("a");
//
//let np = UnsafeMutablePointer<String>.alloc(2);
//np.moveInitializeFrom(p, count: 2);
//(np + 1).initialize("b");
//
//
//print(np[0]);

//struct SS<TT: ForwardIndexType> {
//    
//    func test(a: TT, b: TT){
//        let c = a..<b;
//        print(c.startIndex,c.endIndex);
//    }
//}
//
//let s = SS<Int>();
//s.test(10, b: 15);

var a = [0, 1, 2];
var b = 3;

swap(&a[1], &b);
b;
a;
