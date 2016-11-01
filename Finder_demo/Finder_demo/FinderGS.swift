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
    private var _map: FinderMapProtocol? = nil;
    var finderMap: FinderMapProtocol? {
        if _map == nil {
            _map = self.childNode(withName: "finderMap") as? FinderMapProtocol
        }
        return _map;
    }
}
