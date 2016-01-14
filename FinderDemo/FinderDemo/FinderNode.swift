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



//MARK: == FinderNode ==
class FinderNode: SKShapeNode {
    
    var terrain: FinderTerrain;
    
    let column, row: Int;
    
    //arrow
    let arrow = SKLabelNode();
    
    init(column: Int, row: Int, p: CGPath, terrain: FinderTerrain = .Plian){
        self.terrain = terrain;
        self.column = column;
        self.row = row;
        super.init();
        self.path = p;
        
        updateSkinByTerrain();
        
        let p1 = FinderPoint2D(x: random(), y: random());
        let p2 = FinderPoint2D(x: random(), y: random());
        let d = FinderData(point: p1, g: 0, h: 0, backward: p2);
        self.data = d;
        updateByData();
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
        switch self.terrain{
        case .Mountain:
            self.fillColor = UIColor.blackColor();
        case .River:
            self.fillColor = UIColor.blueColor();
        case .Plian:
            self.fillColor = UIColor.yellowColor();
        case .Obstacle:
            self.fillColor = UIColor.redColor();
        }
    }
    
    ///
    func asPath(){
        self.strokeColor = UIColor.greenColor();
    }
    
    var data: FinderData?{
        didSet{
            updateByData();
        }
    }
    
    private func updateByData(){
        guard let temp = data else{return;}
        if arrow.parent == .None{
            arrow.fontSize = 12;
            arrow.fontColor = UIColor.whiteColor();
//            arrow.position = CGPoint(x: 0, y: (self.frame.size.height - arrow.frame.size.height)/2);
            arrow.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
            self.addChild(arrow);
        }
        let point = temp.point;
        guard let parentpoint = temp.backward else {return;}
        arrow.text = FinderIcon.getIcon(point.x, y1: point.y, x2: parentpoint.x, y2: parentpoint.y).description;
    }
}
