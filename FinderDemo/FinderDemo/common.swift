//
//  FinderData.swift
//  FinderDemo
//
//  Created by 173 on 16/1/14.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import FinderFramework;


///finder data
typealias FinderData = FinderElement<FinderPoint2D>;

//MARK: == FinderTerrain ==
enum FinderTerrain: Int {
    case Plian = 0, River = 10, Mountain = 20, Obstacle = -10
    
    ///next
    mutating func next(){
        let nextRaw = self.rawValue + 10;
        let maxRaw = FinderTerrain.Mountain.rawValue;
        self = nextRaw > maxRaw ? .Obstacle : FinderTerrain(rawValue: nextRaw)!;
    }
}

var fmodel = FModel();

struct FModel {
    var start = FinderPoint2D(x: 0, y: 0);
    var goals = [FinderPoint2D(x: 1, y: 1)];
}