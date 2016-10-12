//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderBFS
///FinderArray<FinderSuccessorsProtocol>.find()
public struct FinderBFS<Vertex: Hashable> {
    
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
extension FinderBFS: FinderSequence {
    public typealias Element = (vertex: Vertex, parent: Vertex?);
    
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
extension FinderBFS {
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
extension FinderBFS {
    public static func find<S>(from v1: Vertex, to v2: Vertex, successors: S) -> [Vertex]?
        where S: FinderSuccessorsProtocol, S.Vertex == Vertex
    {
        var result: [Vertex]? = nil;
        var engine = FinderBFS<S.Vertex>();
        engine.insert((v2, nil));
        
        repeat {
            guard let element = engine.popBest() else {
                break;
            }
            
            let vertex = element.vertex;
            if vertex == v1 {
                result = engine.backtrace(of: vertex);
                break;
            }
            
            for successor in successors.successors(around: vertex) {
                if engine.element(of: successor) == nil {
                    engine.insert((successor, vertex));
                }
            }
        }while true
        return result;
    }
    
    
    public static func find<S>(from vertexs: [Vertex], to vertex: Vertex, successors: S) -> [[Vertex]]
        where S: FinderSuccessorsProtocol, S.Vertex == Vertex
    {
        var result: [[Vertex]] = [];
        
        ///one
        if vertexs.count == 1 {
            let v1 = vertexs[0];
            if let r = find(from: v1, to: vertex, successors: successors) {
                result.append(r);
            }
            return result;
        }
        
        ///more
        var vertexs = vertexs;
        var engine = FinderBFS<S.Vertex>();
        engine.insert((vertex, nil));
        
        repeat {
            guard let element = engine.popBest() else {
                break;
            }
            
            let v = element.vertex;
            if let i = vertexs.index(of: v) {
                let r = engine.backtrace(of: v);
                result.append(r);
                vertexs.remove(at: i);
            }
            if vertexs.isEmpty {
                break;
            }
            
            for successor in successors.successors(around: v) {
                if engine.element(of: successor) == nil {
                    engine.insert((successor, v));
                }
            }
        }while true
        return result;
    }
    
    
    
//    public static func findJPS<S>(from v1: Vertex, to v2: Vertex, successors: S) -> [Vertex]?
//        where S: FinderSuccessorsProtocol & FinderUniformCostProtocol & FinderOptionProtocol, S.Vertex == Vertex
//    {
//        
//        if !successors.jumpable {
//            return find(from: v1, to: v2, successors: successors);
//        }
//        
//        var result: [Vertex]? = nil;
//        var engine = FinderHeap<Vertex>();
//        let origin = FinderElement(vertex: v2, parent: nil, g: 0, h: 0);
//        engine.insert(origin);
//        
//        repeat {
//            guard let element = engine.popBest() else {
//                break;
//            }
//            
//            let vertex = element.vertex;
//            if vertex == v1 {
//                result = engine.backtrace(of: vertex);
//                break;
//            }
//            
//            for successor in successors.successors(around: vertex) {
//                guard let successor = successors.jump(vertex: successor, from: vertex) else {
//                    continue;
//                }
//                let g = element.g + successors.heuristic(from: vertex, to: successor);
//                if let old = engine.element(of: successor) {
//                    if !old.isClosed && old.g > g {
//                        let ele = FinderElement(vertex: successor, parent: vertex, g: g, h: old.h);
//                        let _ = engine.update(ele);
//                    }
//                }
//                else {
//                    let h = successors.heuristic(from: successor, to: v1);
//                    let ele = FinderElement(vertex: successor, parent: vertex, g: g, h: h);
//                    engine.insert(ele);
//                }
//            }
//        }while true
//        return result;
//    }
//    
//    
//    
//    public static func findJPS<S>(from vertexs: [Vertex], to vertex: Vertex, successors: S) -> [[Vertex]]
//        where S: FinderSuccessorsProtocol & FinderUniformCostProtocol & FinderOptionProtocol, S.Vertex == Vertex
//    {
//        
//        if !successors.jumpable {
//            return find(from: vertexs, to: vertex, successors: successors);
//        }
//        
//        var result: [[Vertex]] = [];
//        
//        ///one
//        if vertexs.count == 1 {
//            let v1 = vertexs[0];
//            if let r = findJPS(from: v1, to: vertex, successors: successors) {
//                result.append(r);
//            }
//            return result;
//        }
//        
//        ///more
//        var vertexs = vertexs;
//        var engine = FinderHeap<Vertex>();
//        let origin = FinderElement(vertex: vertex, parent: nil, g: 0, h: 0);
//        engine.insert(origin);
//        
//        repeat {
//            guard let element = engine.popBest() else {
//                break;
//            }
//            
//            let v = element.vertex;
//            if let i = vertexs.index(of: v) {
//                let r = engine.backtrace(of: v);
//                result.append(r);
//                vertexs.remove(at: i);
//            }
//            if vertexs.isEmpty {
//                break;
//            }
//            
//            for successor in successors.successors(around: v) {
//                guard let successor = successors.jump(vertex: successor, from: vertex) else {
//                    continue;
//                }
//                let g = element.g + successors.heuristic(from: vertex, to: successor);
//                if let old = engine.element(of: successor) {
//                    if !old.isClosed && old.g > g {
//                        let ele = FinderElement(vertex: successor, parent: v, g: g, h: old.h);
//                        let _ = engine.update(ele);
//                    }
//                }
//                else {
//                    let ele = FinderElement(vertex: successor, parent: v, g: g, h: 0);
//                    engine.insert(ele);
//                }
//            }
//        }while true
//        return result;
//    }
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


