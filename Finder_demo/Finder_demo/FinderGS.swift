//
//  FinderGS.swift
//  Finder_demo
//
//  Created by 叶贤辉 on 2016/10/21.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation


import SpriteKit
import GameplayKit

class FinderGS: SKScene {
    
//    private let finderMap = FinderMap(columns: 32, rows: 24);
    
    
    var finderMap: SKTileMapNode?;
    
    override func didMove(to view: SKView) {
//        self.finderMap = self.childNode(withName: "finderMap") as? SKTileMapNode;
        
//        let c = self.childNode(withName: "finderContainer")
//        let cc = c as? FinderContainer;
//        print(cc?.la, cc, c)
//        
//        let t = FinderTemp();
//        self.addChild(t);
        
        
        let finderView = FinderView(columns: 32, rows: 24);
        self.addChild(finderView);
    }
    
}
