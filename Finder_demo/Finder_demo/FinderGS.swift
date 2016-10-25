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
    var finderMap: FinderMap? = nil;
    
    override func didMove(to view: SKView) {
        self.finderMap = self.childNode(withName: "finderMap") as? FinderMap;
        print(finderMap);
    }
    
}
