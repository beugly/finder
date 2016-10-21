//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation


public protocol _FinderProtocol: FinderProtocol {
    
    /// The option type
    associatedtype Option: FinderOptionProtocol;
    
    ///option
    var option: Option {get}
}
extension _FinderProtocol where Element == FinderElement<Vertex>, Vertex == Option.Vertex {
    public func successors(around element: Element) -> [(vertex: Vertex, cost: Int)] {
        let vertex = element.vertex;
        var array: [(vertex: Vertex, cost: Int)] = [];
        for neighbor in option.neighbors(around: vertex) {
            guard let cost = option.exactCostOf(neighbor, from: vertex) else {
                continue;
            }
            array.append((neighbor, cost));
        }
        return array;
    }
}


//MARK: FinderProtocol
public protocol FinderProtocol {
    
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /**
     Return successors around element
     */
    func successors(around element: Element) -> [(vertex: Vertex, cost: Int)]
    
    /**
     Make element
     - Returns: element
     */
    func makeElement(vertex: Vertex, cost: Int, parent: Element, target: Vertex) -> Element
    
    /**
      Updates exist element
     */
    func update(exist element: Element, cost: Int, parent: Element) -> Element?
}

//MARK: FinderOneToOne
public protocol FinderOneToOne: FinderProtocol {
    
    /// The FinderSequence type
    associatedtype S: FinderSequence;
    
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Equatable = S.Vertex;
    
    /**
     - Returns: the sequence of 'S'
     */
    func makeSequence() -> S
    
    /**
     Finder from start to goal
     */
    func find(from start: Vertex, to goal: Vertex) -> [Vertex]?
}


//MARK: FinderManyToOne
public protocol FinderManyToOne: FinderProtocol, FinderOneToOne {
    /**
     Finder from starts to goal
     */
    func find(from starts: [Vertex], to goal: S.Vertex) -> [[Vertex]]
}

//MARK: FinderOptionProtocol
public protocol FinderOptionProtocol {
    /// The vertex type
    associatedtype Vertex: Hashable;
    
    /// -Returns: neighbors around 'vertex'
    func neighbors(around vertex: Vertex) -> [Vertex]
    
    /**
     Return 'g' value of 'vertex' from 'parent' vertex
     - Parameters:
        - vertex: the 'vertex' will to be calculate cost
        - parent: the 'parent' vertex
     - Returns: if 'vertex' was invalid return 'nil', otherwise,
        return cost from 'parent' vertex to the 'vertex'.
     */
    func exactCostOf(_ vertex: Vertex, from parent: Vertex) -> Int?
    
    /**
     - Parameter vertex: the 'vertex' that will to be calculate cost
     - Returns: if 'vertex' was invalid return 'nil', otherwise, return cost of the 'vertex'.
     */
    func isValidOf(_ vertex: Vertex) -> Int?
    
    /**
     Return 'h' value
     - Returns: huristic cost from 'v1' to 'v2'.
     */
    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
}

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
     - Returns: cost from 'vertex' to 'jumped' vertex.
     */
    func distance(from vertex: Vertex, to jumped: Vertex) -> Int
}

/*******************************extension*********************************************/

//MARK: extension FinderOneToOne
extension FinderOneToOne where Element == FinderElement<Vertex> {
    public func update(exist element: Element, cost: Int, parent: Element) -> Element? {
        if element.isClosed {
            return nil;
        }
        
        let g = parent.g + cost;
        guard g < element.g else {
            return nil;
        }
        var element = element;
        element.update(parent.vertex, g: g);
        return element;
    }
}
extension FinderOneToOne where S.Vertex == Vertex, S.Element == Element, Element == FinderElement<Vertex> {
    public func find(from start: Vertex, to goal: Vertex) -> [Vertex]? {
        var sequence = _makeSequenceBy(origin: start);
        repeat {
            guard let element = sequence.pop() else {
                break;
            }
            
//            print(element.vertex, element.parent);
            
            let vertex = element.vertex;
            if vertex == goal{
                return sequence.backtrace(of: vertex).reversed();
            }
            
            _expanding(around: element, sequence: &sequence, target: goal);
        }while true
        return nil;
    }
    
    ///expanding
    fileprivate func _expanding(around element: Element, sequence: inout S, target: Vertex){
        for successor in successors(around: element) {
            let v = successor.vertex;
            if let old = sequence.element(of: v) {
//                if old.isClosed {
//                    continue;
//                }
//                
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
    fileprivate func _makeSequenceBy(origin: Vertex) -> S {
        var sequence = makeSequence();
        let origin = Element(vertex: origin, parent: nil, g: 0, h: 0);
        sequence.push(origin);
        return sequence;
    }
}
extension FinderOneToOne where Self.S == FinderHeap<Vertex>, Vertex: Hashable {
    public func makeSequence() -> S {
        return S();
    }
}


//MARK: FinderManyToOne
extension FinderManyToOne {
    public func update(exist element: Element, cost: Int, parent: Element) -> Element? {
        return nil;
    }
}
extension FinderManyToOne where S.Vertex == Vertex, S.Element == Element, Element == FinderElement<Vertex> {
    public func find(from starts: [Vertex], to goal: S.Vertex) -> [[Vertex]] {
        var sequence = _makeSequenceBy(origin: goal);
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
            
            _expanding(around: element, sequence: &sequence, target: goal);
        }while true
        return result;
    }
}
extension FinderManyToOne where Self.S == FinderArray<Vertex>, Vertex: Hashable {
    public func makeSequence() -> S {
        return S();
    }
}

