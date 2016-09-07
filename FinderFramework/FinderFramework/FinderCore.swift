//
//  FinderCore.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//MARK: FStorage
public protocol FStorage {
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Insert a element into 'Self'.
    mutating func insert(element: Element)
    
    ///Remove the best element and close it.
    mutating func removeBest() -> Element?
    
    ///Update element
    mutating func update(newElement: Element)
    
    ///Return element info
    func elementOf(vertex: Vertex) -> Element?
    
    init();
}
extension FStorage {
    ///Element Type
    public typealias Element = FElement<Vertex>;
    
    ///Return Vertex array(backtrace of vertex)
    public func backtrace(vertex: Vertex) -> [Vertex]{
        var result = [vertex];
        var element: Element? = elementOf(vertex);
        repeat {
            guard let vertex = element?.parent else {
                break;
            }
            result.append(vertex);
            element = elementOf(vertex);
        }while true;
        return result;
    }
}

//MARK: FHeap
///Finder Heap
public struct FHeap<Vertex: Hashable> {
    
    ///Element Type
    public typealias Element = FElement<Vertex>;
    
    ///Open list
    internal private(set) var openList: PriorityQueue<Element>;
    
    ///Visited list - [Vertex: Element]
    internal private(set) var visitList: [Vertex: Element];
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<Element>.init(minimum: []);
    }
}
extension FHeap: FStorage {
    
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.insert(element);
        visitList[element.vertex] = element;
    }
    
    ///Remove the best element and close it.
    mutating public func removeBest() -> Element? {
        guard let element = openList.popBest() else {
            return .None;
        }
        visitList[element.vertex]?.isClosed = true;
        return element;
    }
    
    ///Update element
    mutating public func update(newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.indexOf{$0.vertex == vertex}) else {
            return;
        }
        openList.replace(index, newValue: newElement);
        visitList[vertex] = newElement;
    }
    
    
    ///Return element
    public func elementOf(vertex: Vertex) -> Element?{
        return visitList[vertex];
    }
}


//MARK: FElement
public struct FElement<Vertex: Hashable> {
    
    ///Vertex
    public let vertex: Vertex;
    
    ///Parent vertex
    public internal(set) var parent: Vertex?;
    
    ///G represents exact cost, H represents heuristic estimated cost
    public internal(set) var g, h: Int;
    
    ///is closed
    public internal(set) var isClosed: Bool = false;
    
    ///f value, f = g + h;
    public var f: Int {
        return g + h;
    }
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
    }
}
extension FElement: Comparable {}
public func ==<Vertex: Hashable>(lsh: FElement<Vertex>, rsh: FElement<Vertex>) -> Bool{
    return lsh.vertex == rsh.vertex;
}
public func <<Vertex: Hashable>(lsh: FElement<Vertex>, rsh: FElement<Vertex>) -> Bool{
    return lsh.f < rsh.f ? true : (lsh.h < rsh.h);
}