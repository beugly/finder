//
//  Finder3D.swift
//  FinderFramework
//
//  Created by xifangame on 16/11/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//FinderElement3D
public typealias FinderElement3D = FinderElement<FinderVertex3D>;

//MARK: FinderVertex3D
public struct FinderVertex3D{
    ///position in system coordinate
    public var x, y, z: Int;
    
    ///placement weight
    public let placementWeight: CGFloat;
    
    ///init
    public init(x: Int, y: Int, z: Int, placementWeight: CGFloat){
        self.x = x;
        self.y = y;
        self.z = z;
        self.placementWeight = placementWeight;
    }
    
    public var hashValue: Int {
        return x << 10 + y << 10 + z;
    }
}
extension FinderVertex3D: FinderVertexProtocol{}
extension FinderVertex3D: Hashable {}
public func ==(lsh: FinderVertex3D, rsh: FinderVertex3D) -> Bool {
    return lsh.x == rsh.x && lsh.y == rsh.y && lsh.z == rsh.z;
}


////to be continue....
