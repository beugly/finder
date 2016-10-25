//
//  FinderDragable.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/25.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;




class FinderMapBase: SKNode {
    var _lastPosition: CGPoint? = nil;
    
    
    func changeTerrain(at pos: CGPoint) {
        fatalError("changeTerrain(at:) not implemented");
    }
}
extension FinderMapBase {
    
    var isDragging: Bool {
        return _lastPosition != nil;
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let pos = self.convert(pos, to: parent!);
        if let ld = _lastPosition {
            let dragx = pos.x - ld.x;
            let dragy = pos.y - ld.y;
            if abs(dragx) > 5 || abs(dragy) > 5{
                self.position.x += dragx;
                self.position.y += dragy;
                _lastPosition = pos;
            }
        }
        else {
            _lastPosition = pos;
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if _lastPosition != nil {
            _lastPosition = nil;
        }
        else {
            changeTerrain(at: pos);
        }
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

