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
    
    ///vertex, h
    public let vertex: Vertex, h: CGFloat;
    
    ///parent vertex
    public fileprivate(set) var parent: Vertex?;
    
    ///g: exact cost, f: g + h
    public fileprivate(set) var g, f: CGFloat;
    
    ///is closed
    public internal(set) var isClosed: Bool;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: CGFloat, h: CGFloat, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
    
    ///update
    mutating func update(_ parent: Vertex?, g: CGFloat) {
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
