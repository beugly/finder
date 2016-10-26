//
//  FinderGround.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/26.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;
import FinderFramework;


//MARK: FinderMapAbstract
class FinderMapAbstract: SKNode {
    
    fileprivate var _lastPosition: CGPoint? = nil;
    
    ///ground
    var ground: SKTileMapNode? = nil;
    
    ///is dragging
    var isDragging: Bool {
        return _lastPosition != nil;
    }
    
    ///touch down
    func touchDown(atPoint pos : CGPoint) {
    }
    
    ///touch moved
    func touchMoved(toPoint pos : CGPoint) {
        dragSelf(toPoint: convert(pos, to: parent!));
    }
    
    ///touch up
    func touchUp(atPoint pos : CGPoint) {
        dragEnd();
    }
    
    /**
     - Returns: cost of group
     */
    func costOf(_ group: SKTileGroup) -> Int {
        fatalError("costOf(group:) must be implemented");
    }
}
extension FinderMapAbstract: FinderDataSource2D {
    func costOf(x: Int, y: Int) -> Int? {
        guard let g = ground?.tileGroup(atColumn: x, row: y) else {
            return nil;
        }
        return costOf(g);
    }
}
extension FinderMapAbstract {
    //to next group at position
    func toNextGroup(atPosition pos: CGPoint) {
        guard let _ground = ground else {
            return;
        }
        let c = _ground.tileColumnIndex(fromPosition: pos);
        let r = _ground.tileRowIndex(fromPosition: pos);
        toNextGroup(atColumn: c, row: r);
    }
    
    //to next group at column, row
    func toNextGroup(atColumn c: Int, row r: Int) {
        guard let _ground = ground else {
            return;
        }
        var newGroup: SKTileGroup?;
        if let g = _ground.tileGroup(atColumn: c, row: r) {
            let groups = _ground.tileSet.tileGroups;
            if let index = groups.index(of: g) {
                newGroup = (index == groups.count - 1 ? nil : groups[index + 1]);
            }
        }
        else {
            newGroup = _ground.tileSet.tileGroups[0];
        }
        _ground.setTileGroup(newGroup, forColumn: c, row: r);
    }
}
extension FinderMapAbstract {
    ///drag self to point
    func dragSelf(toPoint pos: CGPoint) {
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
    
    ///drag end
    func dragEnd() {
        _lastPosition = nil;
    }
}
extension FinderMapAbstract {
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


