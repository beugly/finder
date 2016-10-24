//
//  FinderMapDelegate.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;


protocol FinderMapDelegate {
    
    func nextTerrainAt(position: CGPoint)
    
    func reset()
}
