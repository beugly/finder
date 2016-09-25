//
//  FProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/9/22.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation






public protocol FinderProtocol00000 {
    
    ///Option type
    associatedtype Option: FinderOptionProtocol;
    
    ///Element type
    associatedtype Element: FinderElementProtocol = FinderElement<Option.Vertex>;
    
    ///Target type
    associatedtype Target;
    
    ///option
    var option: Option {get}
    
    ///make element
    func makeElement(of v: Element.Vertex, from parent: Element, towards target: Target) -> Element
    
    ///update element
    func updateElement(of e: Element, from parent: Element, towards target: Target) -> Element?
}
extension FinderProtocol00000 where Element ==  FinderElement<Option.Vertex> {
    
    ///Heap type
    typealias _Heap = FinderHeap<Option.Vertex>;
    
    ///make heap and insert origin element
    fileprivate func makeHeap(origin: Option.Vertex) -> _Heap {
        var heap = _Heap();
        let originElement = _Heap.Element(vertex: origin, parent: nil);
        heap.insert(element: originElement);
        return heap;
    }
    
    ///expand successors
    fileprivate func expandSuccessors(around element: Element, addTo heap: inout _Heap, towards target: Target) {
        let vertex = element.vertex;
        let successors = option.successors(of: vertex, from: element.parent);
        for successor in successors {
            if let visited = heap.visitedOf(vertex: successor) {
                if visited.isClosed {continue;}
                if let ele = updateElement(of: visited.element, from: element, towards: target) {
                    heap.update(newElement: ele);
                }
            }
            else{
                let ele = makeElement(of: vertex, from: element, towards: target);
                heap.insert(element: ele);
            }
        }
    }
}
extension FinderProtocol00000 where Element ==  FinderElement<Option.Vertex>, Target == Option.Vertex{
    
    ///find
    public func find(from v1: Option.Vertex, to v2: Option.Vertex) -> [Option.Vertex]? {
        var heap = makeHeap(origin: v1);
        var result: [Option.Vertex]? = nil;
        repeat{
            ///get best element
            guard let element = heap.removeBest() else {
                break;
            }
            let vertex = element.vertex;
            
            ///check vertex
            if vertex == v2 {
                result = heap.backtrace(vertex: vertex).reversed();
                break;
            }
            
            ///expand successors
            expandSuccessors(around: element, addTo: &heap, towards: v2);
        }while true;
        return result;
    }
}
extension FinderProtocol00000 where Element ==  FinderElement<Option.Vertex>, Target == [Option.Vertex] {
    ///find
    public func find(from vertexs: [Option.Vertex], to vertex: Option.Vertex) -> [[Option.Vertex]] {
        var heap = makeHeap(origin: vertex);
        var vertexs = vertexs;
        var result: [[Option.Vertex]] = [];
        repeat{
            ///get best element
            guard let element = heap.removeBest() else {
                break;
            }
            
            ///check vertex
            if isGoal(vertex: element.vertex, goals: &vertexs) {
                let r = heap.backtrace(vertex: element.vertex);
                result.append(r);
                break;
            }
            
            ///expand successors
            expandSuccessors(around: element, addTo: &heap, towards: vertexs);
        }while true;
        return result;
    }
    
    ///find goal
    private func isGoal(vertex: Option.Vertex, goals: inout [Option.Vertex]) -> Bool{
        if goals.count == 1 {
            guard vertex == goals[0] else {
                return false;
            }
            goals.remove(at: 0);
            return true;
        }
        
        guard let i = goals.index(of: vertex) else {
            return false;
        }
        goals.remove(at: i);
        return true;
    }
}



//MARK: FinderAStar
public struct FinderAStar2<Option>
    where
    Option: FinderOptionProtocol,
    Option: FinderExactCostProtocol,
    Option: FinderHeuristicProtocol
    
{
    public let option: Option;
    
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderAStar2: FinderProtocol00000 {
    
    public typealias Target = Option.Vertex;
    public typealias Element = FinderElement<Option.Vertex>;
    
    public func makeElement(of v: Option.Vertex, from parent: Element, towards target: Option.Vertex) -> Element {
        let g = parent.g + option.exactCost(from: parent.vertex, to: v);
        let h = option.heuristic(from: v, to: target);
        return Element(vertex: v, parent: parent.vertex, g: g, h: h);
    }
    
    public func updateElement(of e: Element, from parent: Element, towards target: Option.Vertex) -> Element? {
        let g = parent.g + option.exactCost(from: parent.vertex, to: e.vertex);
        guard g < e.g else {
            return nil;
        }
        return Element(vertex: e.vertex, parent: parent.vertex, g: g, h: e.h);
    }
}






