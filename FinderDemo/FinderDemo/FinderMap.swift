//
//  FinderMap.swift
//  FinderDemo
//
//  Created by 叶贤辉 on 16/1/10.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import FinderFramework;
import SpriteKit;

class FinderMap: SKNode {
    
    let node2d: Array2D<FinderNode>;
    
    let GAP: CGFloat = 1;
    
    let nodeSize: CGFloat = 50;
    
    init(columns: Int, rows: Int){
        var nodes: [FinderNode] = [];
        
        for r in 0..<rows{
            let posy: CGFloat = CGFloat(r) * (nodeSize + GAP);
            for c in 0..<columns{
                let n = FinderNode();
                n.position = CGPoint(x: CGFloat(c) * (nodeSize + GAP), y: posy)
                nodes.append(n);
            }
            
        }
        self.node2d = Array2D<FinderNode>(columns: columns, rows: rows, values: nodes);
        super.init();
        nodes.forEach{
            self.addChild($0);
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}