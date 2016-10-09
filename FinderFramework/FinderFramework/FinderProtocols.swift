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
    associatedtype Heap: FinderOpenListProtocol;
    
    ///make heap and insert origin element
    func makeHeap() -> Heap
    
    ///search element
    func search(element: _Element, in heap: Heap) -> (result: [_Vertex]?, isCompleted: Bool)
    
    ///expand successor(of parent) into heap
    func expandSuccessors(around element: _Element, into heap: inout Heap)
    
    ///find
    func find(findOne: ([_Vertex]) -> Void) -> Heap
}
extension FinderProtocol {
    
    ///vertex type
    public typealias _Vertex = Heap.Vertex;
    
    ///element type
    public typealias _Element = FinderElement<_Vertex>;
    
    ///find
    public func find(findOne: ([_Vertex]) -> Void) -> Heap{
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
    
    ///back trace
    func backtrace(of vertex: _Vertex, in heap: Heap) -> [_Vertex] {
        var result = [vertex];
        var e: _Element? = heap.element(of: vertex);
        repeat{
            guard let parent = e?.parent else {
                break;
            }
            result.append(parent);
            e = heap.element(of: parent);
        }while true
        return result;
    }
}

//MARK: FinderOpenListProtocol
public protocol FinderOpenListProtocol {
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///Return visited element of vertex
    func element(of vertex: Vertex) -> FinderElement<Vertex>?
    
    ///Return next element
    mutating func next() -> FinderElement<Vertex>?
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


//MARK: FinderOneToOne
public protocol FinderOneToOne: FinderProtocol {
    ///start vertex
    var start: _Vertex {get}
    
    ///goal vertex
    var goal: _Vertex {get}
    
    ///Option type
    associatedtype Option: FinderOptionProtocol;
    
    ///init
    init(start: Option.Vertex, goal: Option.Vertex, option: Option)
}
extension FinderOneToOne {
    public func search(element: _Element, in heap: Heap) -> (result: [_Vertex]?, isCompleted: Bool) {
        guard goal == element.vertex else {
            return (nil, false);
        }
        let result: [_Vertex] = backtrace(of: element.vertex, in: heap).reversed();
        return (result, true);
    }
    
}
extension FinderOneToOne where Option.Vertex == Heap.Vertex {
    ///static find
    public static func find(from start: Option.Vertex, to goal: Option.Vertex, option: Option) -> [Option.Vertex]? {
        var result: [Option.Vertex]?;
        let f = Self.init(start: start, goal: goal, option: option);
        let _ = f.find{
            result = $0;
        }
        return result;
    }
}
extension FinderOneToOne where Heap == FinderHeap<Option.Vertex> {
    public func makeHeap() -> Heap {
        let origin = _Element(vertex: start, parent: nil, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
}





