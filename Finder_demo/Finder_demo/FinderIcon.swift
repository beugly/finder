//
//  FinderArrow.swift
//  FinderDemo
//
//  Created by 173 on 16/1/12.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation


enum FinderIcon
{
    case l, r, t, b, tl, tr, bl, br
}
extension FinderIcon: CustomStringConvertible
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
    
    static func getIcon(_ x1: Int, y1: Int, x2: Int, y2: Int) -> FinderIcon{
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
