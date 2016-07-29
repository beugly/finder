//
//  FinderCore.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


///FinderHeapType
public protocol FinderHeapType {
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Return visited element at vertex
    func elementOf(vertex: Vertex) -> Element?
    
    ///insert element
    mutating func insert(element: Element)
    
    ///pop element and close it
    mutating func pop() -> Element?
    
    ///update element
    mutating func update(newElement: Element)
    
    ///init
    init();
}
extension FinderHeapType {
    
    ///FinderVertexItem
    public typealias Item = FinderVertexItem<Vertex>;
    
    ///Element Type
    public typealias Element = (item: Item, parent: Item?, isClosed: Bool);
    
    ///parse
    public func parseToItems(vertex: Vertex) -> [Item] {
        guard let element = elementOf(vertex) else {
            return [];
        }
        
        var result: [Item] = [element.item];
        var vertex = vertex;
        repeat{
            guard let parent = elementOf(vertex)?.parent else {
                return result;
            }
            result.append(parent);
            vertex = parent.vertex;
        }while true;
    }
    
    ///parse
    public func parseToVertexes(vertex: Vertex) -> [Vertex] {
        let result: [Item] = parseToItems(vertex);
        return result.flatMap{
            return $0.vertex;
        }
    }
}


///FinderHeap
public struct FinderHeap<T: Hashable> {
    
    ///openlist
    public private(set) var openList: PriorityQueue<FinderHeap.Item>;
    
    ///visitlist - [Vertex: FinderHeap.Element]
    public private(set) var visitList: [Vertex: FinderHeap.Element];
    
    ///init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<FinderHeap.Item>.init(minimum: []);
    }
}
extension FinderHeap: FinderHeapType {
    
    ///Vertex Type
    public typealias Vertex = T;
    
    public func elementOf(vertex: Vertex) -> FinderHeap.Element? {
        return visitList[vertex];
    }
    
    public mutating func insert(element: FinderHeap.Element) {
        openList.insert(element.item);
        visitList[element.item.vertex] = element;
    }
    
    public mutating func pop() -> FinderHeap.Element? {
        guard let item = openList.popBest() else {
            return .None;
        }
        var element = visitList[item.vertex];
        element?.isClosed = true;
        visitList[item.vertex] = element;
        return element;
    }
    
    public mutating func update(newElement: FinderHeap.Element) {
        let vertex = newElement.item.vertex;
        guard let index = (openList.indexOf{$0.vertex == vertex}) else {
            return;
        }
        openList.replace(index, newValue: newElement.item);
        visitList[vertex] = newElement;
    }
}

///FinderArray
public struct FinderArray<T: Hashable> {
    
    ///openlist
    public private(set) var openList: [FinderArray.Vertex];
    
    ///visitlist - [Vertex: FinderHeap.Element]
    public private(set) var visitList: [Vertex: FinderArray.Element];
    
    ///index
    private var index: Int = -1;
    
    ///init
    public init(){
        self.visitList = [:];
        self.openList = [];
    }
}
extension FinderArray: FinderHeapType {
    
    ///Vertex Type
    public typealias Vertex = T;
    
    public func elementOf(vertex: Vertex) -> FinderArray.Element? {
        return visitList[vertex];
    }
    
    public mutating func insert(element: FinderArray.Element) {
        openList.append(element.item.vertex);
        visitList[element.item.vertex] = element;
    }
    
    public mutating func pop() -> FinderArray.Element? {
        index += 1;
        guard index < openList.count else{
            return .None;
        }
        
        let vertex = openList[index];
        var element = visitList[vertex];
        element?.isClosed = true;
        visitList[vertex] = element;
        return element;
    }
    
    public mutating func update(newElement: FinderArray.Element) {
        let vertex = newElement.item.vertex;
        visitList[vertex] = newElement;
    }
}

///FinderVertexItem
public struct FinderVertexItem<Vertex: Hashable> {
    
    ///vertex
    public let vertex: Vertex;
    
    ///g represents exact cost, h represents heuristic estimated cost
    public internal(set) var g, h: Int;
    
    ///f value, f = g + h;
    public var f: Int {
        return g + h;
    }
    
    ///init
    public init(vertex: Vertex, g: Int, h: Int){
        self.vertex = vertex;
        self.g = g;
        self.h = h;
    }
}
extension FinderVertexItem: Comparable {}
public func ==<Vertex: Hashable>(lsh: FinderVertexItem<Vertex>, rsh: FinderVertexItem<Vertex>) -> Bool{
    return lsh.vertex == rsh.vertex;
}
public func <<Vertex: Hashable>(lsh: FinderVertexItem<Vertex>, rsh: FinderVertexItem<Vertex>) -> Bool{
    return lsh.f < rsh.f ? true : (lsh.h < rsh.h);
}




