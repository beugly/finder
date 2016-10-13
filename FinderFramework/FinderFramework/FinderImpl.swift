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
    public func successors(around e: Element) -> [(element: Element, isOpened: Bool)] {
        return [];
    }
}
extension FinderAstar: FinderProtocol{
    public typealias Vertex = T;
    public typealias Element = FinderElement<Vertex>;
}

//MARK: FinderGreedyBFS
/// A greedy best first search
public struct FinderGreedyBFS<T: Hashable> {
    public func successors(around e: Element) -> [(element: Element, isOpened: Bool)] {
        return [];
    }
}
extension FinderGreedyBFS: FinderProtocol{
    public typealias Vertex = T;
    public typealias Element = FinderElement<Vertex>;
}

//MARK: FinderDijkstra
/// A dijkstra search
public struct FinderDijkstra<T: Hashable> {
    public func successors(around e: Element) -> [(element: Element, isOpened: Bool)] {
        return [];
    }
}
extension FinderDijkstra: FinderProtocol{
    public typealias Vertex = T;
    public typealias Element = FinderElement<Vertex>;
}

//MARK: FinderBreadthFirst
/// A dijkstra search
public struct FinderBreadthFirst<T: Hashable> {
    public func successors(around e: Element) -> [(element: Element, isOpened: Bool)] {
        return [];
    }
}
extension FinderBreadthFirst: FinderProtocol{
    public typealias Vertex = T;
    public typealias Element = FinderElement<Vertex>;
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

//MARK: FinderArray
public struct FinderArray<Vertex: Hashable> {

    ///heap
    fileprivate var array: [Element];

    ///visited list
    fileprivate var visitedList: [Vertex: Element];

    ///current index
    fileprivate var currentIndex: Int = 0;

    ///init
    fileprivate init() {
        self.array = [];
        self.visitedList = [:];
    }
}
extension FinderArray: FinderSequence {
    public typealias Element = FinderElement<Vertex>;

    public mutating func insert(_ newElement: Element) {
        array.append(newElement);
        self.visitedList[newElement.vertex] = newElement;
    }

    public mutating func popBest() -> Element? {
        guard currentIndex < array.count else {
            return nil;
        }
        let e = array[currentIndex];
        currentIndex += 1;
        return e;
    }

    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (array.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        array[index] = newElement;
        let old = visitedList[vertex];
        visitedList[vertex] = newElement;
        return old;
    }

    public func element(of vertex: Vertex) -> Element? {
        return visitedList[vertex];
    }
}

//MARK: FinderElement
public struct FinderElement<Vertex: Hashable> {
    ///vertex, h
    public let vertex: Vertex, h: Int;
    
    ///parent vertex
    public private(set) var parent: Vertex?;
    
    ///g: exact cost, f: g + h
    public var g, f: Int;

    ///is closed
    public fileprivate(set) var isClosed: Bool;

    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int = 0, h: Int = 0, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
    
    ///update
    mutating func update(parent: Vertex?, g: Int) {
        self.parent = parent;
        self.g = g;
        self.f = h + g;
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
