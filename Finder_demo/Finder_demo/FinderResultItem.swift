//
//  FinderResultItem.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/26.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit
import FinderFramework;

class FinderResultItem: SKShapeNode {
    private var _lable: SKLabelNode? = nil;
    private var _ghLable: SKLabelNode? = nil;
    func update(by data: FinderElement2D, isPath: Bool) {
        self.strokeColor = UIColor.blue;
        self.glowWidth = isPath ? 2 : 0;
        if _lable == nil{
            _lable = SKLabelNode();
            _lable?.horizontalAlignmentMode = .center;
            _lable?.verticalAlignmentMode = .center;
            _lable?.fontSize = 26;
            self.addChild(_lable!);
            
//            _ghLable = SKLabelNode(fontNamed: "HelveticaNeue");
//            _ghLable?.zPosition = 1;
//            _ghLable?.fontColor = UIColor.black;
//            _ghLable?.fontSize = 12;
//            self.addChild(_ghLable!);
            
        }
        let v = data.vertex;
        let p = data.parent ?? data.vertex;
        _lable?.text = FinderDirection.direction(from: (p.x, p.y), to: (v.x, v.y));
        
//        _ghLable?.text = "\(data.g) \(data.h) \(data.f)";
//        _ghLable?.text = "\(data.g)";
    }
    
    private static let _node = FinderResultItem(rectOf: CGSize(width: 58, height: 58));
    static func create(data: FinderElement2D, isPath: Bool) -> FinderResultItem{
        let n = (_node.copy() as?  FinderResultItem);
        n?.update(by: data, isPath: isPath)
        return n!;
    }
}
