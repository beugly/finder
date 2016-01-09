//
//  FinderNode.swift
//  FinderDemo
//
//  Created by 叶贤辉 on 16/1/10.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;
import FinderFramework;

///finder data
typealias FinderData = FinderElement<FinderPoint2D>;

//MARK: == FinderTerrain ==
enum FinderTerrain: Int {
    case Plian = 1, River = 10, Mountain = 20, Obstacle = 0
}

//MARK: == FinderNode ==
public class FinderNode: SKShapeNode {
    
    var terrain: FinderTerrain;
    
    init(terrain: FinderTerrain = .Plian){
        self.terrain = terrain;
        super.init();
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
