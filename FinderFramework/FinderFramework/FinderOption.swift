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
    associatedtype Vertex;
    
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

//MARK: FinderJumpableOption
public protocol FinderJumpableOption: FinderOptionProtocol {
//    /**
//     Return jumped vertex from parent to vertex
//     - Returns: jumped vertex that between 'vertex' to 'parent' if the jumped vertex was invalid,
//     otherwise, 'nil'
//     */
//    func jump(vertex: Vertex, from parent: Vertex) -> Vertex?
    
    
    /// -Returns: jumpable neighbors around 'vertex' that from 'parent'
    func jumpableNeighbors(around vertex: Vertex, parent: Vertex?) -> [Vertex]
    
    /**
     - Returns: distance cost from 'vertex' to 'jumped' vertex.
     */
    func distance(from vertex: Vertex, to jumped: Vertex) -> CGFloat
}
