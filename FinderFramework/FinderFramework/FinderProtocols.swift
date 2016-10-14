//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: FinderSuccessorsProtocol
public protocol FinderSuccessorsProtocol {
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    ///successors around vertex
    func successors(around vertex: Vertex) -> [Vertex]
}

//MARK: FinderHeuristic
public protocol FinderHeuristic: FinderSuccessorsProtocol {
    /// - Returns: huristic cost from 'v1' to 'v2'.
    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
}

//MARK: FinderJumpable
/// A FinderJumpable protocol, for jump point search
public protocol FinderJumpable: FinderSuccessorsProtocol, FinderHeuristic {
    /// - Returns: jump vertex
    func jump(vertex: Vertex, from parent: Vertex) -> Vertex?
}




