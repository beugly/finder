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
    
    ///find
    func find(findOne: ([Heap.Vertex]) -> Void) -> Heap
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
extension FinderOpenListProtocol {
    ///back trace
    final public func backtrace(of vertex: Vertex) -> [Vertex] {
        var result = [vertex];
        var e: FinderElement<Vertex>? = element(of: vertex);
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
    
    ///Option type
    associatedtype Option: FinderOptionProtocol;
    
    ///start vertex
    var start: _Vertex {get}
    
    ///goal vertex
    var goal: _Vertex {get}
    
    ///init
    init(start: _Vertex, goal: _Vertex, option: Option)
    
    ///expand successor(of parent) into heap
    func expandSuccessors(around element: FinderElement<_Vertex>, into heap: inout FinderHeap<_Vertex>)
}
extension FinderOneToOne {
    ///vertex type
    public typealias _Vertex = Option.Vertex;
    
    ///static find
    public static func find(from start: _Vertex, to goal: _Vertex, option: Option) -> [_Vertex]? {
        var result: [_Vertex]?;
        let f = Self.init(start: start, goal: goal, option: option);
        let _ = f.find{
            result = $0;
        }
        return result;
    }
    
    ///find
    public func find(findOne: ([_Vertex]) -> Void) -> FinderHeap<_Vertex>{
        let origin = FinderElement(vertex: start, parent: nil, g: 0, h: 0);
        var heap = FinderHeap<_Vertex>();
        heap.insert(element: origin);
        repeat {
            //get best element
            guard let element = heap.next() else {
                break;
            }
            
            //check state
            let vertex = element.vertex;
            if goal == vertex {
                let result: [Option.Vertex] = heap.backtrace(of: vertex).reversed();
                findOne(result);
                break;
            }
            
            //expand successors
            expandSuccessors(around: element, into: &heap);
        }while true
        return heap;
    }
}


