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

class FinderResultItem: SKSpriteNode {
    private var lable: SKLabelNode;
    init(data: FinderElement<FinderVertex2D>){
        self.lable = SKLabelNode();
        super.init(texture: nil, color: UIColor.green, size: CGSize(width: 64, height: 64));
        let v = data.vertex;
        let p = data.parent ?? data.vertex;
        let text = FinderIcon.getIcon(p.x, y1: p.y, x2: v.x, y2: v.y).description;
        self.lable.text = text;
        self.addChild(lable);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
