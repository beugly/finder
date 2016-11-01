//
//  FinderArrow.swift
//  FinderDemo
//
//  Created by 173 on 16/1/12.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation


enum FinderDirection
{
    case l, r, t, b, tl, tr, bl, br
}
extension FinderDirection: CustomStringConvertible
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
    
    static func direction(from p1: (x: Int, y: Int), to p2: (x: Int, y: Int)) -> String {
        var d: FinderDirection? = nil;
        switch(p2.x - p1.x, p2.y - p1.y){
        case let (dx, dy) where dx == 0 && dy < 0:
            d = .b;
        case let (dx, dy) where dx < 0 && dy < 0:
            d = .bl;
        case let (dx, dy) where dx < 0 && dy == 0:
            d = .l;
        case let (dx, dy) where dx < 0 && dy > 0:
            d = .tl;
        case let (dx, dy) where dx == 0 && dy > 0:
            d = .t;
        case let (dx, dy) where dx > 0 && dy > 0:
            d = .br;
        case let (dx, dy) where dx > 0 && dy == 0:
            d = .r;
        case let (dx, dy) where dx > 0 && dy < 0:
            d = .br;
        default:
            d = nil;
        }
        return d?.description ?? "";
    }
}
