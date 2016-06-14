//
//  CollectionNDTest.swift
//  X_Framework
//
//  Created by xifanGame on 15/9/17.
//  Copyright © 2015年 yeah. All rights reserved.
//

import UIKit
@testable import FinderFramework;

func array2DTest()
{
    let columns = 4;
    let rows = 3;
//    var a2d = Array2D<Int?>(columns: columns, rows: rows, repeatValue: 0);
    var a2d = Array2D<Int>(columns: columns, rows: rows, repeatValue: 0);
    print(a2d.debugDescription);
    var i = 0;
    for r in 0..<rows
    {
        for c in 0..<columns
        {
            a2d[c, r] = i;
            i+=1;
        }
    }
    print(a2d.debugDescription);
    print(a2d.count)
    a2d[1, 1] = 99;
    print(a2d.debugDescription);
    a2d[3,2] = 99;
    print(a2d.debugDescription);
}