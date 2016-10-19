//
//  FinderSequence.swift
//  FinderFramework
//
//  Created by xifangame on 16/10/14.
//  Copyright © 2016年 xifangame. All rights reserved.
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
    
    /// Updates the given element.
    /// - Parameter newElement: the new element
    /// - Returns: element equal to `newElement` if the sequence already contained
    ///   such a element; otherwise, `nil`.
    @discardableResult
    mutating func update(_ newElement: Element) -> Element?
    
    /// Return the element to associate with `vertex`
    func element(of vertex: Vertex) -> (element: Element, isClosed: Bool)?
}
extension FinderSequence where Element == FinderElement<Vertex> {
    /// Backtrace
    /// - Returns: [vertex, parent vertex, parent vertex...,origin vertex]
    public func backtrace(of vertex: Vertex) -> [Vertex] {
        var result = [vertex];
        var v: Element? = element(of: vertex)?.element;
        repeat{
            guard let parent = v?.parent else {
                break;
            }
            result.append(parent);
            v = element(of: parent)?.element;
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
    public fileprivate(set) var record: FinderRecord<Vertex, Element>;
    
    ///init
    public init() {
        self.heap = PriorityQueue<Element>{
            $0.f < $1.f ? true : ($0.h < $1.h);
        };
        self.record = FinderRecord<Vertex, Element>.init();
    }
}
extension FinderHeap: FinderSequence {
    public typealias Element = FinderElement<Vertex>;
    
    public mutating func insert(_ newElement: Element) {
        heap.enqueue(newElement);
        record.openValue(newElement, forKey: newElement.vertex);
    }
    
    public mutating func popBest() -> Element? {
        guard let e = heap.dequeue() else {
            return nil;
        }
        record.closeValue(e, forKey: e.vertex);
        return e;
    }
    
    @discardableResult
    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (heap.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        heap.update(newElement, at: index);
        return record.openValue(newElement, forKey: vertex);
    }
    
    public func element(of vertex: Vertex) -> (element: Element, isClosed: Bool)? {
        if let e = record.value(isClosed: vertex) {
            return (e, true);
        }
        else if let e = record.value(isOpened: vertex) {
            return (e, false);
        }
        return nil;
    }
}

//MARK: FinderArray
public struct FinderArray<Vertex: Hashable> {
    
    ///heap
    fileprivate var array: [Element];
    
    ///visited list
    public fileprivate(set) var record: FinderRecord<Vertex, Element>;
    
    ///current index
    fileprivate var currentIndex: Int = 0;
    
    ///init
    public init() {
        self.array = [];
        self.record = FinderRecord<Vertex, Element>.init();
    }
}
extension FinderArray: FinderSequence {
    public typealias Element = FinderElement<Vertex>;
    
    public mutating func insert(_ newElement: Element) {
        array.append(newElement);
        record.openValue(newElement, forKey: newElement.vertex);
    }
    
    public mutating func popBest() -> Element? {
        guard currentIndex < array.count else {
            return nil;
        }
        let e = array[currentIndex];
        record.closeValue(e, forKey: e.vertex);
        currentIndex += 1;
        return e;
    }
    
    @discardableResult
    public mutating func update(_ newElement: Element) -> Element? {
        let vertex = newElement.vertex;
        guard let index = (array.index{ vertex == $0.vertex; }) else {
            return nil;
        }
        array[index] = newElement;
        return record.openValue(newElement, forKey: vertex);
    }
    
    public func element(of vertex: Vertex) -> (element: Element, isClosed: Bool)? {
        if let e = record.value(isClosed: vertex) {
            return (e, true);
        }
        else if let e = record.value(isOpened: vertex) {
            return (e, false);
        }
        return nil;
    }
}


//MARK: FinderRecord
/// A finder record
public struct FinderRecord<Key: Hashable, Value> {
    /// opened list
    fileprivate var openedList: [Key: Value];
    
    /// closed list
    fileprivate var closedList: [Key: Value];
    
    ///init
    public init(){
        self.openedList = [:];
        self.closedList = [:];
    }
    
    /// Open value for key
    @discardableResult
    public mutating func openValue(_ value: Value, forKey: Key) -> Value? {
        return openedList.updateValue(value, forKey: forKey);
    }
    
    /// Close value for key
    public mutating func closeValue(_ value: Value, forKey: Key) {
        openedList.removeValue(forKey: forKey);
        closedList.updateValue(value, forKey: forKey);
    }
    
    /// Return colsed value for key
    public func value(isClosed forKey: Key) -> Value? {
        return closedList[forKey];
    }
    
    /// Return opened value for key
    public func value(isOpened forKey: Key) -> Value?{
        return openedList[forKey];
    }
    
    /// Return record value for key
    public func value(isRecord forKey: Key) -> Value? {
        return closedList[forKey] ?? openedList[forKey];
    }
}

//MARK: FinderElement
public struct FinderElement<Vertex: Hashable> {
    ///vertex, h
    public let vertex: Vertex, h: Int;
    
    ///parent vertex
    public fileprivate(set) var parent: Vertex?;
    
    ///g: exact cost, f: g + h
    public fileprivate(set) var g, f: Int;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
    }
    
    ///update
    mutating func update(_ parent: Vertex?, g: Int) {
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
        return "vertex: \(vertex), parent: \(parent), f: \(f), g: \(g), h: \(h)";
    }
    public var debugDescription: String {
        return description;
    }
}
