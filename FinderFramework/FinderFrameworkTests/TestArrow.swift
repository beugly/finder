//
//  TestArrow.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/27.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation


enum TestArrow
{
    case l, r, t, b, tl, tr, bl, br
}
extension TestArrow:CustomStringConvertible
{
    var description:String{
        switch self{
        case .l:
            return "⬅️";
        case .r:
            return "➡️";
        case .t:
            return "⬆️";
        case .b:
            return "⬇️";
        case .tl:
            return "↖️";
        case .tr:
            return "↗️";
        case .bl:
            return "↙️";
        case .br:
            return "↘️";
        }
    }
    
    static func getArrow(_ x1: Int, y1: Int, x2: Int, y2: Int) -> TestArrow{
        switch(x1 - x2, y1 - y2){
        case let (dx, dy) where dx == 0 && dy < 0:
            return .t;
        case let (dx, dy) where dx < 0 && dy < 0:
            return .tl;
        case let (dx, dy) where dx < 0 && dy == 0:
            return .l;
        case let (dx, dy) where dx < 0 && dy > 0:
            return .bl;
        case let (dx, dy) where dx == 0 && dy > 0:
            return .b;
        case let (dx, dy) where dx > 0 && dy > 0:
            return .br;
        case let (dx, dy) where dx > 0 && dy == 0:
            return .r;
        case let (dx, dy) where dx > 0 && dy < 0:
            return .tr;
        default:
            return .t;
        }
    }
}
