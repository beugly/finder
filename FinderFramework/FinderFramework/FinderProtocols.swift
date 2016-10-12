//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: FinderSequence
/// A finder sequence
public protocol FinderSequence{
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /// Inserts the given element into the sequence unconditionally.
    /// - Parameter newElement: An element to insert into the sequence
    mutating func insert(_ newElement: Element)
    
    /// Pop the best element
    /// - Returns: the best element if the sequence is not empty; othewise, 'nil'
    mutating func popBest() -> Element?
    
    /// Inserts the given element into the sequence unconditionally.
    /// - Parameter newElement: An element to insert into the sequence
    /// - Returns: element equal to `newElement` if the sequence already contained
    ///   such a element; otherwise, `nil`.
    mutating func update(_ newElement: Element) -> Element?
    
    /// Return element of vertex.
    /// - Parameters:
    ///   - vertex: The vertex to associate with `element`
    /// - Returns: the existing associated element of 'vertex'
    ///   if 'vertex' already in the sequence; otherwise, 'nil'.
    func element(of vertex: Vertex) -> Element?
}


//MARK: FinderProtocol
public protocol FinderProtocol {
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /// A type that can represent the 'target'.
    associatedtype Target = Vertex;
    
    /// Make element of 'vertex' whose parent is 'element'
    /// - Parameters: 
    ///   - vertex: The vertex to associate with `element`
    ///   - parent: The element of parent vertex
    ///   - target: The target Vertex or [Vertex]
    /// - Returns: The element of vertex
    func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element
}

//MARK: FinderExactCostProtocol
public protocol FinderExactCostProtocol: FinderProtocol {
    
    /// Return exact cost from 'v1' to 'v2'
    /// - Parameters: 
    ///   - v1: from vertex
    ///   - v2: to vertex
    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
    
    /// Make element of 'existElement'
    func makeElementOf(_ existElement: Element, parent: Element) -> Element?
}

//MARK: FinderHeuristicProtocol
public protocol FinderHeuristicProtocol: FinderProtocol {
    /// Heuristic function
    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
    
    /// Make element of 'vertex' whose parent is 'element'
    /// Target must be Vertex
    /// - Parameters:
    ///   - vertex: The vertex to associate with `element`
    ///   - parent: The element of parent vertex
    ///   - target: The target vertex
    /// - Returns: The element of vertex
    func makeElementOf(_ vertex: Vertex, parent: Element, target: Vertex) -> Element
}


//MARK: extension FinderProtocol: FinderExactCostProtocol
extension FinderProtocol where Self: FinderExactCostProtocol, Element == FinderElement<Vertex> {
    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Vertex) -> Element {
        let parentVertex = parent.vertex;
        let g = exactCost(from: parentVertex, to: vertex);
        let ele = Element(vertex: vertex, parent: parentVertex, g: g, h: 0);
        return ele;
    }
    
    public func makeElementOf(_ existElement: Element, parent: Element) -> Element? {
        guard !existElement.isClosed else {
            return nil;
        }
        let vertex = existElement.vertex;
        let parentVertex = parent.vertex;
        let g = exactCost(from: parentVertex, to: vertex);
        
        guard g < existElement.g else {
            return nil;
        }
        
        let ele = FinderElement(vertex: vertex, parent: parentVertex, g: g, h: existElement.h);
        return ele;
    }
}

//MARK: extension FinderProtocol: FinderHeuristicProtocol
extension FinderProtocol where Self: FinderHeuristicProtocol, Element == FinderElement<Vertex> {
    /// Make element of 'vertex' whose parent is 'element'
    /// - Parameters:
    ///   - vertex: The vertex to associate with `element`
    ///   - parent: The element of parent vertex
    ///   - target: The target vertex
    /// - Returns: The element of vertex
    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Vertex) -> Element {
        let parentVertex = parent.vertex;
        let h = heuristic(from: vertex, to: target);
        let ele = Element(vertex: vertex, parent: parentVertex, g: 0, h: h);
        return ele;
    }
}


//MARK: extension FinderProtocol: FinderExactCostProtocol & FinderHeuristicProtocol
extension FinderProtocol
    where
    Self: FinderExactCostProtocol & FinderHeuristicProtocol,
    Element == FinderElement<Vertex>
{
    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Vertex) -> Element {
        let parentVertex = parent.vertex;
        let g = exactCost(from: parentVertex, to: vertex);
        let h = heuristic(from: vertex, to: target);
        let ele = Element(vertex: vertex, parent: parentVertex, g: g, h: h);
        return ele;
    }
}








//MARK: FinderSuccessorsProtocol
public protocol FinderSuccessorsProtocol {
    ///vertex type
    associatedtype Vertex: Hashable;
    
    ///successors around vertex
    func successors(around vertex: Vertex) -> [Vertex]
}


////MARK: FinderUniformCostProtocol
/////the cost of vertex must be unified.
//public protocol FinderUniformCostProtocol {
//    ///vertex type
//    associatedtype Vertex;
//    
//    ///if jumpable is true use jump point search
//    var jumpable: Bool {get}
//    
//    ///return jump point
//    func jump(vertex: Vertex, from v: Vertex) -> Vertex?
//}
//
////MARK: FinderMultiformCostProtocol
//public protocol FinderMultiformCostProtocol {
//    ///vertex type
//    associatedtype Vertex;
//    
//    ///if the vertex can be expanding return cost of vertex, otherwise return nil
//    func cost(of vertex: Vertex) -> Int?
//}
//extension FinderMultiformCostProtocol {
//    ///if the vertex can be expanding return true, othewise return false
//    public func isValid(of vertex: Self.Vertex) -> Bool {
//        return cost(of: vertex) != nil;
//    }
//}
//
////MARK: FinderOptionProtocol
//public protocol FinderOptionProtocol {
//    ///Vertex Type
//    associatedtype Vertex: Hashable;
//
//    ///Return exact cost from v1 to v2
//    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
//
//    ///heuristic
//    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
//
//    ///Return successor vertexs around vertex
//    func successors(around vertex: Vertex) -> [Vertex]
//}


