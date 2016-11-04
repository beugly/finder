//
//  FinderIconNode.swift
//  Finder_demo
//
//  Created by xifangame on 16/11/4.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;
import FinderFramework;


enum FinderIconType {
    case Start, Goal, Direction((Int, Int), (Int, Int))
}


class FinderIconNode: SKShapeNode {
    private static let iconLabelName = "iconLabel";
    func update(iconType: FinderIconType, isPath: Bool) {
        var iconText = "";
        switch iconType {
        case .Start:
            iconText = "🚹";
        case .Goal:
            iconText = "🚺";
        case .Direction(let f, let t):
            iconText = FinderDirection.direction(from: f, to: t);
        }
        let l = self.childNode(withName: FinderIconNode.iconLabelName) as? SKLabelNode ?? SKLabelNode();
        l.name = FinderIconNode.iconLabelName;
        l.text = iconText;
        
        self.strokeColor = UIColor.blue;
        self.glowWidth = isPath ? 2 : 0;
    }
    
    func showScore(f: Int, g: Int? = nil, h: Int? = nil) {
        setLabel(key: "f", value: f, position: CGPoint.zero);
        if let g = g {
            setLabel(key: "g", value: g, position: CGPoint.zero);
        }
        if let h = h {
            setLabel(key: "h", value: h, position: CGPoint.zero);
        }
    }
    
    private func setLabel(key: String, value: Int, position pos: CGPoint) {
        let labelName = "\(key)Lable";
        var l: SKLabelNode;
        if let _l = childNode(withName: labelName) as? SKLabelNode {
            l = _l;
        }
        else {
            l = SKLabelNode(fontNamed: "HelveticaNeue");
            l.name = labelName;
            l.position = pos;
            self.addChild(l);
        }
        l.text = "\(key): \(value)";
    }
}
