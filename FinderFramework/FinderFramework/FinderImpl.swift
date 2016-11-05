//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation











public struct FinderAstar<Option: FinderOptionProtocol> {
    public let option: Option;
    public init(option: Option) {
        self.option = option;
    }
    
}
extension FinderAstar: FinderProtocol, FinderOneToOne {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let h = option.heuristic(from: vertex, to: target);
        let g = parent.g + cost;
        return S.Element(vertex: vertex, parent: parent.vertex, g: g, h: h);
    }
}
extension FinderAstar: _FinderProtocol {}


public struct FinderGreedyBest<T: FinderOptionProtocol> {
    public let option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderGreedyBest: FinderProtocol, FinderOneToOne {
    public typealias S = FinderHeap<Option.Vertex>;
    public typealias Option = T;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        let vertex = element.vertex;
        var array: [(vertex: S.Vertex, cost: Int)] = [];
        for neighbor in option.neighbors(around: vertex){
            guard let cost = option.isValidOf(neighbor) else {
                continue;
            }
            array.append((neighbor, cost));
        }
        return array;
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let h = option.heuristic(from: vertex, to: target);
        return S.Element(vertex: vertex, parent: parent.vertex, g: 0, h: h, isClosed: true);
    }
    
    public func update(exist element: S.Element, cost: Int, parent: S.Element) -> S.Element? {
        return nil;
    }
}

public struct FinderDijkstra<Option: FinderOptionProtocol> {
    public let option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderDijkstra: FinderProtocol, FinderOneToOne {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let g = parent.g + cost;
        return S.Element(vertex: vertex, parent: parent.vertex, g: g, h: 0);
    }
}
extension FinderDijkstra: _FinderProtocol {}

public struct FinderBFS<T: FinderOptionProtocol> {
    public let option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderBFS: FinderProtocol, FinderOneToOne, FinderManyToOne {
    public typealias S = FinderArray<Option.Vertex>;
    public typealias Option = T;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        let vertex = element.vertex;
        var array: [(vertex: S.Vertex, cost: Int)] = [];
        for neighbor in option.neighbors(around: vertex){
            guard let _ = option.isValidOf(neighbor) else {
                continue;
            }
            array.append((neighbor, 1));
        }
        return array;
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        //set isClosed = true
        return S.Element(vertex: vertex, parent: parent.vertex, g: 0, h: 0, isClosed: true);
    }
}



