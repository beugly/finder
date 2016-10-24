//
//  FinderMap.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;




struct FinderMap {
    ///tile map
    fileprivate let map: SKTileMapNode;
    
    ///display
    var display: SKNode {
        return _display;
    }
    
    let _display: SKNode = SKNode();
    
    init(columns: Int, rows: Int, size: Int = 64) {
        let mapSet = SKTileSet(named: "Finder Ground")!;
        map = SKTileMapNode(tileSet: mapSet, columns: columns, rows: rows, tileSize: CGSize(width: size, height: size));
        map.fill(with: mapSet.tileGroups[0]);
        
        _display.addChild(map);
        let sk = SKSpriteNode(color: UIColor.black, size: CGSize(width: 300, height: 400));
        _display.addChild(sk);
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let c = map.tileColumnIndex(fromPosition: pos);
        let r = map.tileRowIndex(fromPosition: pos);
        let g = map.tileGroup(atColumn: c, row: r);
        print(g);
        
        
        _display.xScale += 0.1;
        _display.yScale += 0.1;
        
    }
    
    
    ///columns
    var columns: Int {
        return map.numberOfColumns;
    }
    
    ///rows
    var rows: Int {
        return map.numberOfRows;
    }
    
    ///tile size
    var tileSize: CGSize {
        return map.tileSize;
    }
    
    ///map size
    var mapSize: CGSize {
        return map.mapSize;
    }
}
