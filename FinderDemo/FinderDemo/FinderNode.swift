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
    case Plian = 0, River = 10, Mountain = 20, Obstacle = -10
    
    ///next
    mutating func next(){
        let nextRaw = self.rawValue + 10;
        let maxRaw = FinderTerrain.Mountain.rawValue;
        self = nextRaw > maxRaw ? .Obstacle : FinderTerrain(rawValue: nextRaw)!;
    }
}

//MARK: == FinderNode ==
class FinderNode: SKSpriteNode {
    
    var terrain: FinderTerrain;
    
    let column, row: Int;
    
    init(column: Int, row: Int, terrain: FinderTerrain = .Plian){
        self.terrain = terrain;
        self.column = column;
        self.row = row;
        super.init(texture: .None, color: UIColor.redColor(), size: CGSize(width: nodeSize, height: nodeSize));
        updateSkinByTerrain();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func changeToNextTerrain(){
        self.terrain.next();
        updateSkinByTerrain();
    }
    
    private func updateSkinByTerrain(){
        print(self.terrain.rawValue)
        switch self.terrain{
        case .Mountain:
            self.color = UIColor.blackColor();
        case .River:
            self.color = UIColor.blueColor();
        case .Plian:
            self.color = UIColor.yellowColor();
        case .Obstacle:
            self.color = UIColor.redColor();
        }
    }
}
