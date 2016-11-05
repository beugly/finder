//
//  FinderVertex.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/11/5.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

////MARK: FinderVertexProtocol
//public protocol FinderVertexProtocol {
//    var placementWeight: Int {get}
//}

//MARK: FinderVertex2D
public struct FinderVertex2D{
    
    public typealias T = Int;
    
    ///position in system coordinate
    public var x, y: T;
    
    ///init
    public init(x: T, y: T){
        self.x = x;
        self.y = y;
    }
    
    public var hashValue: Int {
        return x << 10 + y;
    }
}
extension FinderVertex2D: Hashable {}
public func ==(lsh: FinderVertex2D, rsh: FinderVertex2D) -> Bool {
    return lsh.x == rsh.x && lsh.y == rsh.y;
}

//MARK: FinderVertex3D
public struct FinderVertex3D{
    public typealias T = Int;
    ///position in system coordinate
    public var x, y, z: T;
    
    ///init
    public init(x: T, y: T, z: T){
        self.x = x;
        self.y = y;
        self.z = z;
    }
    
    public var hashValue: Int {
        return x << 10 + y << 10 + z;
    }
}
extension FinderVertex3D: Hashable {}
public func ==(lsh: FinderVertex3D, rsh: FinderVertex3D) -> Bool {
    return lsh.x == rsh.x && lsh.y == rsh.y && lsh.z == rsh.z;
}
