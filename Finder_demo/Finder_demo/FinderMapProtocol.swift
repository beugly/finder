//
//  FinderMapProtocol.swift
//  Finder_demo
//
//  Created by xifangame on 16/11/1.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;
import FinderFramework;


protocol FinderMapProtocol: FinderDataSource2D {
    
    ///set starts
    func setStarts(at positions: CGPoint...)
    
    ///set goals
    func setGoal(at position: CGPoint...)
    
    ///set terrain
    func setTerrain(at position: CGPoint)
    
    ///showResult
    func showResult(path: [FinderVertex2D], record: [FinderVertex2D: FinderElement2D])
}
