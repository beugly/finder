//
//  FinderDataStructrues.swift
//  FinderFramework
//
//  Created by xifangame on 16/10/14.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderSequence
public protocol FinderSequence{
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /**
     - Returns: element to associate with 'vertex'
     */
    func element(of vertex: Vertex) -> Element?
    
    /**
     Push the given element into the queue.
     - Parameter newElement: An element to push into the sequence
     */
    mutating func push(_ newElement: Element)
    
    /**
     Pop the optimal element
     - Returns: the optimal element that was removed, or 'nil' if the sequence is empty.
     */
    mutating func pop() -> Element?
    
    /**
     Updates the element stored in the queue at the given index
     - Parameters:
     - element: the new element
     - Returns: element equal to `newElement` if the sequence already contained
        such a element; otherwise, `nil`
     */
    @discardableResult
    mutating func update(_ newElement: Element) -> Element?
}
extension FinderSequence where Element == FinderElement<Vertex> {
    /// Backtrace
    /// - Returns: [vertex, parent vertex, parent vertex...,origin vertex]
    public func backtrace(of vertex: Vertex) -> [Vertex] {
        var result = [vertex];
        var v: Element? = element(of: vertex);
        repeat{
            guard let parent = v?.parent else {
                break;
            }
            result.append(parent);
            v = element(of: parent);
        }while true
        return result;
    }
}

//MARK: FinderHeap
///A finder heap
public struct FinderHeap<Vertex: Hashable> {
    
    ///heap
    fileprivate var heap: PriorityQueue<Element>;
    
    ///visited list
    public fileprivate(set) var record: [Vertex: Element];
    
    ///init
    public init() {
        self.heap = PriorityQueue<Element>{
            $0.f < $1.f ? true : ($0.h < $1.h);
        };
        self.record = [:]
    }
}
extension FinderHeap: FinderSequence {
    public typealias Element = FinderElement<Vertex>;
    
    public mutating func push(_ newElement: Element) {
        heap.enqueue(newElement);
        record.updateValue(newElement, forKey: newElement.vertex);
    }
    
    public mutating func pop() -> Element? {
        guard let e = heap.dequeue() else {
            return nil;
        }
        record[e.vertex]?.isClosed = true;
        return e;
    }
    
    @discardableResult
    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (heap.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        let e = heap.elements[index];
        heap.update(newElement, at: index);
        record[vertex] = newElement;
        return e;
    }
    
    public func element(of vertex: Vertex) -> Element? {
        return record[vertex];
    }
}

//MARK: FinderArray
public struct FinderArray<Vertex: Hashable> {
    
    ///heap
    fileprivate var array: [Element];
    
    ///visited list
    public fileprivate(set) var record: [Vertex: Element];
    
    ///current index
    fileprivate var currentIndex: Int = 0;
    
    ///init
    public init() {
        self.array = [];
        self.record = [:];
    }
}
extension FinderArray: FinderSequence {
    public typealias Element = FinderElement<Vertex>;
    
    public mutating func push(_ newElement: Element) {
        array.append(newElement);
        record.updateValue(newElement, forKey: newElement.vertex);
    }
    
    public mutating func pop() -> Element? {
        guard currentIndex < array.count else {
            return nil;
        }
        let e = array[currentIndex];
//        record[e.vertex]?.isClosed = true;
        currentIndex += 1;
        return e;
    }
    
    @discardableResult
    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (array.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        let e = array[index];
        array[index] = newElement;
        record[vertex] = newElement;
        return e;
    }
    
    public func element(of vertex: Vertex) -> Element? {
        return record[vertex];
    }
}

//MARK: FinderElement
public struct FinderElement<Vertex> {
    ///vertex, h
    public let vertex: Vertex, h: Int;
    
    ///parent vertex
    public fileprivate(set) var parent: Vertex?;
    
    ///g: exact cost, f: g + h
    public fileprivate(set) var g, f: Int;
    
    ///is closed
    public internal(set) var isClosed: Bool;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
    
    ///update
    mutating func update(_ parent: Vertex?, g: Int) {
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
