//
//  FinderOption.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/11/5.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderOptionProtocol
public protocol FinderOptionProtocol {
    /// The vertex type
    associatedtype Vertex: Hashable, FinderVertexProtocol;
    
    /// -Returns: valid neighbors around 'vertex'
    func neighbors(around vertex: Vertex) -> [Vertex]
    
    /**
     * Returns the estimated heuristic cost to reach the indicated 'target' vertex from 'current' vertex
     */
    func estimatedCost(from current: Vertex, to target: Vertex) -> CGFloat

    /**
     * Returns the actual cost to reach the indicated 'current' vertex from 'parent' vertex
     */
    func cost(of current: Vertex, from parent: Vertex) -> CGFloat
}

















////MARK: FinderOptionProtocol
//public protocol FinderOptionProtocol {
//    /// The vertex type
//    associatedtype Vertex: Hashable;
//    
//    /// -Returns: neighbors around 'vertex'
//    func neighbors(around vertex: Vertex) -> [Vertex]
//    
//    /**
//     Return 'g' value of 'vertex' from 'parent' vertex
//     - Parameters:
//     - vertex: the 'vertex' will to be calculate cost
//     - parent: the 'parent' vertex
//     - Returns: if 'vertex' was invalid return 'nil', otherwise,
//     return cost from 'parent' vertex to the 'vertex'.
//     */
//    func exactCostOf(_ vertex: Vertex, from parent: Vertex) -> Int?
//    
//    /**
//     - Parameter vertex: the 'vertex' that will to be calculate cost
//     - Returns: if 'vertex' was invalid return 'nil', otherwise, return cost of the 'vertex'.
//     */
//    func isValidOf(_ vertex: Vertex) -> Int?
//    
//    /**
//     Return 'h' value
//     - Returns: huristic cost from 'v1' to 'v2'.
//     */
//    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
//}

//MARK: FinderJumpable
public protocol FinderJumpable: FinderOptionProtocol {
    /**
     Return jumped vertex from parent to vertex
     - Returns: jumped vertex that between 'vertex' to 'parent' if the jumped vertex was invalid,
     otherwise, 'nil'
     */
    func jump(vertex: Vertex, from parent: Vertex) -> Vertex?
    
    
    /// -Returns: jumpable neighbors around 'vertex' that from 'parent'
    func jumpableNeighbors(around vertex: Vertex, parent: Vertex?) -> [Vertex]
    
    
    /**
     - Returns: distance cost from 'vertex' to 'jumped' vertex.
     */
    func distance(from vertex: Vertex, to jumped: Vertex) -> Int
}
