//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

public struct FinderAstar<Option: FinderOptionProtocol> {
    fileprivate let _option: Option;
    
}
extension FinderAstar: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        return [];
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let h = 0; // return h by option
        let g = parent.g + cost;
        return S.Element(vertex: vertex, parent: parent.vertex, g: g, h: h);
    }
    
    public func update(exist element: S.Element, cost: Int, parent: S.Element) -> S.Element? {
        let g = parent.g + cost;
        guard g < element.g else {
            return nil;
        }
        var element = element;
        element.update(parent.vertex, g: g);
        return element;
    }
}


public struct FinderGreedyBest<Option: FinderOptionProtocol> {
    fileprivate let _option: Option;
    
}
extension FinderGreedyBest: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        return [];
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let h = 0; // return h by option
        return S.Element(vertex: vertex, parent: parent.vertex, g: 0, h: h);
    }
    
    public func update(exist element: S.Element, cost: Int, parent: S.Element) -> S.Element? {
        return nil;
    }
}

public struct FinderDijkstra<Option: FinderOptionProtocol> {
    fileprivate let _option: Option;
    
}
extension FinderDijkstra: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        return [];
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        let g = parent.g + cost;
        return S.Element(vertex: vertex, parent: parent.vertex, g: g, h: 0);
    }
    
    public func update(exist element: S.Element, cost: Int, parent: S.Element) -> S.Element? {
        let g = parent.g + cost;
        guard g < element.g else {
            return nil;
        }
        var element = element;
        element.update(parent.vertex, g: g);
        return element;
    }
}

public struct FinderBFS<Option: FinderOptionProtocol> {
    fileprivate let _option: Option;
    
}
extension FinderBFS: FinderProtocol, FinderManyToOne {
    public typealias S = FinderArray<Option.Vertex>;
    
    public func successors(around element: S.Element) -> [(vertex: S.Vertex, cost: Int)] {
        return [];
    }
    
    public func makeElement(vertex: S.Vertex, cost: Int, parent: S.Element, target: S.Vertex) -> S.Element {
        //set isClosed = true
        return S.Element(vertex: vertex, parent: parent.vertex, g: 0, h: 0, isClosed: true);
    }
    
    public func update(exist element: S.Element, cost: Int, parent: S.Element) -> S.Element? {
        return nil;
    }
}



