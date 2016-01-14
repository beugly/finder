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
    case L, R, T, B, TL, TR, BL, BR
}
extension FinderIcon: CustomStringConvertible
{
    var description:String{
        switch self{
        case .L:
            return "⬅️";
        case .R:
            return "➡️";
        case .T:
            return "⬆️";
        case .B:
            return "⬇️";
        case .TL:
            return "↖️";
        case .TR:
            return "↗️";
        case .BL:
            return "↙️";
        case .BR:
            return "↘️";
        }
    }
    
    static func getIcon(x1: Int, y1: Int, x2: Int, y2: Int) -> FinderIcon{
        switch(x1 - x2, y1 - y2){
        case let (dx, dy) where dx == 0 && dy < 0:
            return .T;
        case let (dx, dy) where dx < 0 && dy < 0:
            return .TL;
        case let (dx, dy) where dx < 0 && dy == 0:
            return .L;
        case let (dx, dy) where dx < 0 && dy > 0:
            return .BL;
        case let (dx, dy) where dx == 0 && dy > 0:
            return .B;
        case let (dx, dy) where dx > 0 && dy > 0:
            return .BR;
        case let (dx, dy) where dx > 0 && dy == 0:
            return .R;
        case let (dx, dy) where dx > 0 && dy < 0:
            return .TR;
        default:
            return .T;
        }
    }
}