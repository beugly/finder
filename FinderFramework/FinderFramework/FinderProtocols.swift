//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: FinderProtocol
public protocol FinderProtocol {
    ///heap type
    associatedtype Heap: FinderIteratorProtocl;
    
    ///vertex type
    associatedtype Vertex: Hashable;
    
    ///make heap and insert origin element
    func makeHeap() -> Heap
    
    ///search element
    func search(element: Heap.Element, in heap: Heap) -> (result: [Vertex]?, isCompleted: Bool)
    
    ///expand successor(of parent) into heap
    func expandSuccessors(around element: Heap.Element, into heap: inout Heap)
    
    ///find
    func find(findOne: ([Vertex]) -> Void) -> Heap
}
extension FinderProtocol {
    ///find
    public func find(findOne: ([Vertex]) -> Void) -> Heap{
        var heap = self.makeHeap();
        repeat {
            //get best element
            guard let element = heap.next() else {
                break;
            }
            
            //check state
            let state = search(element: element, in: heap);
            if let result = state.result{
                findOne(result);
            }
            if state.isCompleted{
                break;
            }
            
            //expand successors
            expandSuccessors(around: element, into: &heap);
        }while true
        return heap;
    }
}

//MARK: FinderOneToOne
public protocol FinderOneToOne: FinderProtocol {
    ///start vertex
    var start: Vertex {get}
    
    ///goal vertex
    var goal: Vertex {get}
}
extension FinderOneToOne where Heap == FinderHeap<Vertex> {
    public func makeHeap() -> Heap {
        let origin = FinderElement(vertex: start, parent: nil, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
}
extension FinderOneToOne
    where
    Heap.Element: FinderElementProtocol,
    Heap.Element.Vertex == Heap.Vertex,
    Heap.Vertex == Vertex
{
    public func search(element: Heap.Element, in heap: Heap) -> (result: [Heap.Vertex]?, isCompleted: Bool) {
        guard goal == element.vertex else {
            return (nil, false);
        }
        let result: [Heap.Vertex] = heap.backtrace(vertex: goal).reversed();
        return (result, true);
    }
}

//MARK: FinderIteratorProtocl
public protocol FinderIteratorProtocl: IteratorProtocol {
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///Return visited element info
    func visitedOf(vertex: Vertex) -> (element: Element, isClosed: Bool)?
}
extension FinderIteratorProtocl where Element: FinderElementProtocol, Element.Vertex == Vertex {
    ///back trace
    func backtrace(vertex: Vertex) -> [Vertex] {
        var result = [vertex];
        var element: Element? = visitedOf(vertex: vertex)?.element;
        repeat{
            guard let parent = element?.parent else {
                break;
            }
            result.append(parent);
            element = visitedOf(vertex: parent)?.element;
        }while true
        return result;
    }
}

//MARK: FinderElementProtocol
public protocol FinderElementProtocol{
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///vertex
    var vertex: Vertex{get}
    
    ///parent
    var parent: Vertex?{get}
}

//MARK: FinderOptionProtocol
public protocol FinderOptionProtocol {
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Return successor vertexs of vertex from parent vertex
    func successors(of vertex: Vertex, from parent: Vertex?) -> [Vertex]
    
    ///Return exact cost from v1 to v2
    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
    
    ///heuristic
    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
}


