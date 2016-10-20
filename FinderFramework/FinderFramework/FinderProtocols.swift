//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: FinderProtocol
public protocol FinderProtocol {
    /// The FinderSequence type
    associatedtype S: FinderSequence;
    
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Equatable = S.Vertex;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = S.Element;
    
    /**
     Make sequence
     */
    func makeSequence() -> S
    
    /**
     Return successors around element
     */
    func successors(around element: Element) -> [(vertex: S.Vertex, cost: Int)]
    
    /**
     Make element
     - Returns: element
     */
    func makeElement(vertex: Vertex, cost: Int, parent: Element, target: Vertex) -> Element
    
    /**
      Updates exist element
     */
    func update(exist element: Element, cost: Int, parent: Element) -> Element?
    
    /**
     Finder from start to goal
     */
    func find(from start: Vertex, to goal: Vertex) -> [Vertex]?
}
extension FinderProtocol where S.Vertex == Vertex, S.Element == Element, Element == FinderElement<Vertex> {
    
    ///expanding
    fileprivate func expanding(around element: Element, sequence: inout S, target: Vertex){
        for successor in successors(around: element) {
            let v = successor.vertex;
            if let old = sequence.element(of: v) {
                if old.isClosed {
                    continue;
                }
                
                if let ele = update(exist: old, cost: successor.cost, parent: element) {
                    sequence.update(ele);
                }
            }
            else{
                let ele = makeElement(vertex: v, cost: successor.cost, parent: element, target: target);
                sequence.push(ele);
            }
        }
    }
    
    /// - Returns: sequence was made by origin
    fileprivate func makeSequenceBy(origin: Vertex) -> S {
        var sequence = makeSequence();
        let origin = Element(vertex: origin, parent: nil, g: 0, h: 0);
        sequence.push(origin);
        return sequence;
    }
    
    public func find(from start: Vertex, to goal: Vertex) -> [Vertex]? {
        var sequence = makeSequenceBy(origin: start);
        repeat {
            guard let element = sequence.pop() else {
                break;
            }
            
            let vertex = element.vertex;
            if vertex == goal{
                return sequence.backtrace(of: vertex).reversed();
            }
            
            expanding(around: element, sequence: &sequence, target: goal);
        }while true
        return nil;
    }
}
extension FinderProtocol where Self.S == FinderHeap<Vertex>, Vertex: Hashable {
    public func makeSequence() -> S {
        return S();
    }
}
extension FinderProtocol where Self.S == FinderArray<Vertex>, Vertex: Hashable {
    public func makeSequence() -> S {
        return S();
    }
}


//MARK: FinderManyToOne
public protocol FinderManyToOne: FinderProtocol {
    /**
     Finder from starts to goal
     */
    func find(from starts: [Vertex], to goal: S.Vertex) -> [[Vertex]]
}
extension FinderManyToOne {
    
    public func update(exist element: Element, cost: Int, parent: Element) -> Element? {
        return nil;
    }
}
extension FinderManyToOne where S.Vertex == Vertex, S.Element == Element, Element == FinderElement<Vertex> {
    public func find(from starts: [Vertex], to goal: S.Vertex) -> [[Vertex]] {
        var sequence = makeSequenceBy(origin: goal);
        var vertexs = starts;
        var result: [[Vertex]] = [];
        repeat {
            guard let element = sequence.pop() else {
                break;
            }
            
            let vertex = element.vertex;
            
            if let i = vertexs.index(of: vertex) {
                let r: [S.Vertex] = sequence.backtrace(of: vertex);
                result.append(r);
                vertexs.remove(at: i);
                if vertexs.isEmpty {
                    break;
                }
            }
            
            expanding(around: element, sequence: &sequence, target: goal);
        }while true
        return result;
    }
}












public protocol FinderOptionProtocol {
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    /// return neighbors
    func neighbors(around vertex: Vertex) -> [Vertex]
}

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
    
    
    ///Return successors around vertex whose parent vertex is 'parent'
    func findSuccessors(around vertex: Vertex, parent: Vertex?) -> [Vertex]
}



public protocol FinderExactCosting: FinderSuccessorsProtocol{
    /// - Returns: exact cost from 'v1' to 'v2'.
    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
}








