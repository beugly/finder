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
    
    //arrow
    let arrow = SKLabelNode();
    
    init(column: Int, row: Int, terrain: FinderTerrain = .Plian){
        self.terrain = terrain;
        self.column = column;
        self.row = row;
        super.init(texture: .None, color: UIColor.redColor(), size: CGSize(width: nodeSize, height: nodeSize));
        updateSkinByTerrain();
        
        
        let p1 = FinderPoint2D(x: 0, y: 0);
        let p2 = FinderPoint2D(x: 1, y: 1);
        let d = FinderData(point: p1, g: 0, h: 0, backward: p2);
        updateBy(d);
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
    
    func updateBy(data: FinderData){
        if arrow.parent == .None{
            arrow.fontSize = 10;
            self.addChild(arrow);
        }
        
        
        let point = data.point;
        guard let parentpoint = data.backward else {return;}
        arrow.text = FinderArrow.getArrow(point.x, y1: point.y, x2: parentpoint.x, y2: parentpoint.y).description;
    }
}
