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


let nodeSize: CGFloat = 20;

class FinderMap: SKNode {
    
    let GAP: CGFloat = 1;
    
    var node2d: Array2D<FinderNode>;
    
    var model: FinderModel = .Straight;
    
    var heuristic:FinderHeuristic2D = .Manhattan;
    
    var isMutiGoal: Bool = false;
    
    var findCallBack: (() -> Void)?;
    
    typealias Point = FinderPoint2D;
    
    init(columns: Int = 35, rows: Int = 35){
        let posxOffset = nodeSize + GAP;
        let offset: CGFloat = nodeSize / 2;
        var nodes: [FinderNode?] = [];
        
        for r in 0..<rows{
            let posy: CGFloat = CGFloat(r) * posxOffset + offset;
            for c in 0..<columns{
                let n = FinderNode(column: c, row: r);
                n.position = CGPoint(x: CGFloat(c) * posxOffset + offset, y: posy)
                nodes.append(n);
            }
            
        }
        self.node2d = Array2D<FinderNode>(columns: columns, rows: rows, values: nodes);
        super.init();
        self.userInteractionEnabled = true;
        nodes.forEach{
            guard let n = $0 else {return;}
            self.addChild(n);
        }
    }
    
    func setGoalsType(single: Bool){
        self.isMutiGoal = !single;
        //do sth
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let location = touches.first?.locationInNode(self) else {return;}
        guard let n = self.nodeAtPoint(location) as? FinderNode else{return;}
        n.changeToNextTerrain();
        findCallBack?();
    }
}
extension FinderMap: FinderOption2DType{
    ///return calculate movement cost from f to t if it is validity(and exist)
    ///otherwise return nil
    func getCost(x: Int, y: Int) -> CGFloat? {
        guard x > -1 && x < self.node2d.columns && y > -1 && y < self.node2d.rows else {return .None;}
        guard let terrain = self.node2d[x, y]?.terrain where terrain != .Obstacle else {return .None;}
        return CGFloat(terrain.rawValue);
    }
}
