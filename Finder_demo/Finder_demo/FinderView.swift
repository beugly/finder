//
//  FinderContainer.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation;
import SpriteKit;


class FinderView: SKNode {
    ///tile map
    fileprivate let map: SKTileMapNode;
    
    init(columns: Int, rows: Int, size: Int = 64) {
        let mapSet = SKTileSet(named: "Finder Ground")!;
        map = SKTileMapNode(tileSet: mapSet, columns: columns, rows: rows, tileSize: CGSize(width: size, height: size));
        map.fill(with: mapSet.tileGroups[0]);
        super.init();
        self.addChild(map);
        self.isUserInteractionEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate var lastDrag: CGPoint? = nil;
}
extension FinderView {
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        //        let c = finderMap!.tileColumnIndex(fromPosition: pos);
        //        let r = finderMap!.tileRowIndex(fromPosition: pos);
        //        let g = finderMap?.tileGroup(atColumn: c, row: r);
        //        print(g?.name);
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let ld = lastDrag {
            let dragx = pos.x - ld.x;
            let dragy = pos.y - ld.y;
            if abs(dragx) > 5 || abs(dragy) > 5{
                map.position.x += dragx;
                map.position.y += dragy;
                lastDrag = pos;
            }
        }
        else {
            lastDrag = pos;
        }
        print(pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        lastDrag = nil;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
