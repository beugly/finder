//
//  FinderCore.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//MARK: FinderHeap
public protocol FinderHeap {
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Element Type
    associatedtype Element = FElement<Vertex>;
    
    ///Insert a element into 'Self'.
    mutating func insert(_ element: Element)
    
    ///Remove the best element and close it.
    mutating func removeBest() -> Element?
    
    ///Update element
    mutating func update(_ newElement: Element)
    
    ///Return element info
    func elementOf(_ vertex: Vertex) -> Element?
    
    ///back trace
    func backtrace(_ element: Element) -> [Vertex]
}
extension FinderHeap where Self.Element == FElement<Self.Vertex> {
    
    ///back trace
    public func backtrace(_ element: Element) -> [Vertex] {
        var result = [element.vertex];
        var element: Element = element;
        repeat {
            guard let p = element.parent, let ele = elementOf(p) else {
                break;
            }
            result.append(p);
            element = ele;
        }while true
        return result.reversed();
    }
}

//MARK: FHeap
public struct FHeap<Vertex: Hashable> {
    ///Open list
    internal fileprivate(set) var openList: PriorityQueue<Element>;
    
    ///Visited list - [Vertex: Element]
    internal fileprivate(set) var visitList: [Vertex: Element];
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<Element>.heap(minimum: [])
    }
}
extension FHeap: FinderHeap {
    
    ///Element Type
    public typealias Element = FElement<Vertex>;
    
    ///Insert a element into 'Self'.
    mutating public func insert(_ element: Element) {
        openList.insert(element: element);
        visitList[element.vertex] = element;
    }
    
    ///Remove the best element and close it.
    mutating public func removeBest() -> Element? {
        guard let element = openList.popBest() else {
            return .none;
        }
        visitList[element.vertex]?.isClosed = true;
        return element;
    }
    
    ///Update element
    mutating public func update(_ newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.index{$0.vertex == vertex}) else {
            return;
        }
        openList.replace(newValue: newElement, at: index);
        visitList[vertex] = newElement;
    }
    
    
    ///Return element
    public func elementOf(_ vertex: Vertex) -> Element?{
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
