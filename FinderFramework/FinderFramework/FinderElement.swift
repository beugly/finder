//
//  FinderElement.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/11/5.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderElement
public struct FinderElement<Vertex> {
    
    ///value type
    public typealias T = Int;
    
    ///vertex, h
    public let vertex: Vertex, h: T;
    
    ///parent vertex
    public fileprivate(set) var parent: Vertex?;
    
    ///g: exact cost, f: g + h
    public fileprivate(set) var g, f: T;
    
    ///is closed
    public internal(set) var isClosed: Bool;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: T, h: T, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
    
    ///update
    mutating func update(_ parent: Vertex?, g: T) {
        self.parent = parent;
        self.g = g;
        self.f = h + g;
    }
}
extension FinderElement: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "vertex: \(vertex), parent: \(parent), f: \(f), g: \(g), h: \(h)";
    }
    public var debugDescription: String {
        return description;
    }
}

//FinderElement2D
public typealias FinderElement2D = FinderElement<FinderVertex2D>;
//FinderElement3D
public typealias FinderElement3D = FinderElement<FinderVertex3D>;
