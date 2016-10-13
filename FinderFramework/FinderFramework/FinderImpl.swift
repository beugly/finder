//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderAstar
/// A astar search
public struct FinderAstar<T: Hashable> {
    public func exactCost(from v1: Vertex, to v2: Vertex) -> Int {
        return 0;
    }
    public func heuristic(from vertex: Vertex, to target: Vertex) -> Int {
        return 0;
    }
}
extension FinderAstar: FinderProtocol{
    public typealias Vertex = T;
}
extension FinderAstar: FinderHeuristic{}
extension FinderAstar: FinderExactCosting{}


//MARK: FinderGreedyBFS
/// A greedy best first search
public struct FinderGreedyBFS<T: Hashable> {
    public func heuristic(from vertex: Vertex, to target: Vertex) -> Int {
        return 0;
    }
}
extension FinderGreedyBFS: FinderProtocol{
    public typealias Vertex = T;
}
extension FinderGreedyBFS: FinderHeuristic{}


//MARK: FinderDijkstra
/// A dijkstra search
public struct FinderDijkstra<T: Hashable> {
    public func exactCost(from v1: Vertex, to v2: Vertex) -> Int {
        return 0;
    }
}
extension FinderDijkstra: FinderProtocol{
    public typealias Vertex = T;
}
extension FinderDijkstra: FinderExactCosting{}


//MARK: FinderBreadthFirst
/// A dijkstra search
public struct FinderBreadthFirst<T: Hashable> {}
extension FinderBreadthFirst: FinderProtocol{
    public typealias Vertex = T;
}






//MARK: FinderHeap
///A finder heap
public struct FinderHeap<Vertex: Hashable> {
    
    ///heap
    fileprivate var heap: PriorityQueue<Element>;
    
    ///visited list
    fileprivate var visitedList: [Vertex: Element];
    
    ///init
    public init() {
        self.heap = PriorityQueue<Element>.init(isOrderedBefore: {
            return $0.f < $1.f ? true : ($0.h < $1.h);
        });
        self.visitedList = [:];
    }
}
extension FinderHeap: FinderSequence {
    public typealias Element = FinderElement<Vertex>;
    
    public mutating func insert(_ newElement: Element) {
        self.heap.insert(newElement);
        self.visitedList[newElement.vertex] = newElement;
    }
    
    public mutating func popBest() -> Element? {
        guard let e = heap.popBest() else {
            return nil;
        }
        visitedList[e.vertex]?.isClosed = true;
        return e;
    }
    
    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (heap.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        heap.updateElement(newElement, atIndex: index);
        let old = visitedList[vertex];
        visitedList[vertex] = newElement;
        return old;
    }
    
    public func element(of vertex: Vertex) -> Element? {
        return visitedList[vertex];
    }
}
extension FinderHeap {
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

//MARK: FinderElement
public struct FinderElement<Vertex: Hashable> {
    ///vertex, parent vertex
    public let vertex: Vertex, parent: Vertex?;
    
    ///g: exact cost, h: estimate cost, f: g + h
    public let g, h, f: Int;

    ///is closed
    public fileprivate(set) var isClosed: Bool;

    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
}
extension FinderElement: Comparable {}
public func ==<Vertex: Hashable>(lsh: FinderElement<Vertex>, rsh: FinderElement<Vertex>) -> Bool{
    return lsh.vertex == rsh.vertex;
}
public func <<Vertex: Hashable>(lsh: FinderElement<Vertex>, rsh: FinderElement<Vertex>) -> Bool{
    return lsh.f < rsh.f ? true : (lsh.h < rsh.h);
}
extension FinderElement: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "vertex: \(vertex), parent: \(parent), f: \(f), g: \(g), h: \(h), isClosed: \(isClosed)";
    }
    public var debugDescription: String {
        return description;
    }
}


