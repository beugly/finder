//
//  FinderCore.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FRequestOneToOne
public struct FRequestOneToOne<Vertex: Hashable> {
    let goal: Vertex;
    public init(goal: Vertex){
        self.goal = goal;
    }
}
extension FRequestOneToOne: FinderRequest{
    public func search(of vertex: Vertex) -> (found: Bool, completed: Bool) {
        guard vertex == goal else {
            return (false, false);
        }
        return (true, true);
    }
}

//MARK: FRequestManyToOne
public struct FRequestManyToOne<Vertex: Hashable> {
    fileprivate(set) var goals: [Vertex];
    public init(goals: [Vertex]){
        self.goals = goals;
    }
}
extension FRequestManyToOne: FinderRequest {
    public mutating func search(of vertex: Vertex) -> (found: Bool, completed: Bool) {
        guard let i = goals.index(of: vertex) else {
            return (false, false);
        }
        goals.remove(at: i);
        return (true, goals.isEmpty);
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
