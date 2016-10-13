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
    @discardableResult
    mutating func update(_ newElement: Element) -> Element?
    
    /// Return element of vertex.
    /// - Parameters:
    ///   - vertex: The vertex to associate with `element`
    /// - Returns: the existing associated element of 'vertex'
    ///   if 'vertex' already in the sequence; otherwise, 'nil'.
    func element(of vertex: Vertex) -> Element?
}
extension FinderSequence where Element == FinderElement<Vertex> {
    ///find one to one
    public mutating func find<T>(from v1: Vertex, to v2: Vertex, finder: T) -> [Vertex]?
        where T: FinderProtocol, T.Vertex == Vertex, T.Element == FinderElement<Vertex>
    {
        let origin = Element(vertex: v1, parent: nil);
        insert(origin);
        repeat {
            guard let e = popBest() else {
                break;
            }
            
            if v2 == e.vertex {
                return backtrace(of: v2).reversed();
            }
            
            for successor in finder.successors(around: e) {
                let ele = successor.element;
                if !successor.isOpened {
                    insert(ele);
                }
                else {
                    update(ele);
                }
            }
        }while true;
        return nil;
    }
    
    ///find many to one
    public mutating func find<T>(from vertexs: [Vertex], to vertex: Vertex, finder: T) -> [[Vertex]]
        where T: FinderProtocol, T.Vertex == Vertex, T.Element == FinderElement<Vertex>
    {
        var result: [[Vertex]] = [];
        var vertexs = vertexs;
        let origin = Element(vertex: vertex, parent: nil);
        insert(origin);
        repeat {
            guard let e = popBest() else {
                break;
            }
            
            let v = e.vertex;
            if let i = vertexs.index(of: v) {
                result.append(backtrace(of: v));
                vertexs.remove(at: i);
                if vertexs.isEmpty {
                    break;
                }
            }
            
            for successor in finder.successors(around: e) {
                let ele = successor.element;
                if !successor.isOpened {
                    insert(ele);
                }
                else {
                    update(ele);
                }
            }
        }while true;
        return result;
    }
    
    ///backtrace
    /// - Returns: [vertex, parent vertex, parent vertex...,origin vertex]
    func backtrace(of vertex: Vertex) -> [Vertex] {
        var result = [vertex];
        var e: Element? = element(of: vertex);
        repeat{
            guard let parent = e?.parent else {
                break;
            }
            result.append(parent);
            e = element(of: parent);
        }while true
        return result;
    }
    
}

////MARK: FinderProtocol
public protocol FinderProtocol {
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /// Return successors around element
    /// - Parameter e: parent element
    /// - Returns: return successors array
    func successors(around e: Element) -> [(element: Element, isOpened: Bool)]
}

////MARK: FinderProtocol
//public protocol FinderProtocol {
//    /// A type that can represent the vertex to associate with `element`
//    associatedtype Vertex: Hashable;
//    
//    /// A type that can represent the element to associate with `vertex`
//    associatedtype Element = FinderElement<Vertex>;
//    
//    /// A type that can represent the target vertex or [target vertex]
//    associatedtype Target = Vertex;
//    
//    /// Make element of 'vertex' whose parent is 'element'
//    /// - Parameters: 
//    ///   - vertex: The vertex to associate with `element`
//    ///   - parent: The element of parent vertex
//    ///   - target: The target vertex or [target vertex]
//    /// - Returns: The element of vertex
//    func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element
//    
//    /// Revise exist 'element'
//    /// - Parameters: 
//    ///   - element: The existElement
//    ///   - parent: The parent element
//    /// - Returns: revised element of exist 'element'
//    func reviseExist(_ element: Element, parent: Element) -> Element?
//}
//extension FinderProtocol {
//    public func reviseExist(_ element: Element, parent: Element) -> Element? {
//        return nil;
//    }
//}
//extension FinderProtocol where Element == FinderElement<Vertex> {
//    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element {
//        let parentVertex = parent.vertex;
//        let ele = Element(vertex: vertex, parent: parentVertex, g: 0, h: 0);
//        return ele;
//    }
//}
////MARK: extension FinderProtocol: FinderHeuristic
//extension FinderProtocol where Self: FinderHeuristic, Element == FinderElement<Vertex> {
//    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element {
//        let parentVertex = parent.vertex;
//        let h = heuristic(from: vertex, to: target);
//        let ele = Element(vertex: vertex, parent: parentVertex, g: 0, h: h);
//        return ele;
//    }
//}
////MARK: extension FinderProtocol: FinderExactCosting
//extension FinderProtocol where Self: FinderExactCosting, Element == FinderElement<Vertex> {
//    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element {
//        let parentVertex = parent.vertex;
//        let g = exactCost(from: parentVertex, to: vertex);
//        let ele = Element(vertex: vertex, parent: parentVertex, g: g, h: 0);
//        return ele;
//    }
//    
//    public func reviseExist(_ element: Element, parent: Element) -> Element? {
//        guard !element.isClosed else {
//            return nil;
//        }
//        let vertex = element.vertex;
//        let parentVertex = parent.vertex;
//        let g = exactCost(from: parentVertex, to: vertex);
//        
//        guard g < element.g else {
//            return nil;
//        }
//        
//        let ele = FinderElement(vertex: vertex, parent: parentVertex, g: g, h: element.h);
//        return ele;
//    }
//}
////MARK: extension FinderProtocol: FinderExactCostProtocol & FinderHeuristicProtocol
//extension FinderProtocol
//    where
//    Self: FinderExactCosting & FinderHeuristic,
//    Element == FinderElement<Vertex>
//{
//    public func makeElementOf(_ vertex: Vertex, parent: Element, target: Target) -> Element {
//        let parentVertex = parent.vertex;
//        let g = exactCost(from: parentVertex, to: vertex);
//        let h = heuristic(from: vertex, to: target);
//        let ele = Element(vertex: vertex, parent: parentVertex, g: g, h: h);
//        return ele;
//    }
//}
//
////MARK: FinderExactCosting
//public protocol FinderExactCosting: FinderProtocol {
//    /// - Returns: exatc cost from 'v1' to 'v2'. used by g value.
//    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
//}
//
////MARK: FinderHeuristic
//public protocol FinderHeuristic: FinderProtocol {
//    /// - Returns: huristic cost from 'vertex' to 'target'. used by h value.
//    func heuristic(from vertex: Vertex, to target: Target) -> Int
//}
//
//
//
//
//
//
//
//
//
//
////MARK: FinderSuccessorsProtocol
//public protocol FinderSuccessorsProtocol {
//    ///vertex type
//    associatedtype Vertex: Hashable;
//    
//    ///successors around vertex
//    func successors(around vertex: Vertex) -> [Vertex]
//}
//

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


