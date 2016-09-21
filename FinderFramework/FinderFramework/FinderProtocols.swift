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
    associatedtype Heap: FinderHeapProtocol;
    
    ///make heap and insert origin element
    func makeHeap() -> Heap
    
    ///search element
    func search(element: Heap.Element) -> (found: Bool, completed: Bool)
    
    ///Return successor elements around element
    func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)]
}
extension FinderProtocol{
    ///find
    public func find(findOne: ([Heap.Element.Vertex]) -> Void) -> Heap{
        var heap = self.makeHeap();
        repeat {
            //get best element
            guard let element = heap.removeBest() else {
                break;
            }
            
            //check state
            let state = search(element: element);
            if state.found{
                let result = heap.backtrace(vertex: element.vertex);
                findOne(result);
            }
            if state.completed{
                break;
            }
            
            //expand successors
            let _successors = successors(around: element, in: heap);
            for successor in _successors {
                let isOpened = successor.isOpened;
                let ele = successor.element;
                !isOpened ? heap.insert(element: ele) : heap.update(newElement: ele);
            }
        }while true
        return heap;
    }
}

//MARK: FinderHeapProtocol
public protocol FinderHeapProtocol {
    
    ///Element Type
    associatedtype Element: FinderElementProtocol;
    
    ///Insert a element into 'Self'.
    mutating func insert(element: Element)
    
    ///Remove the best element and close it.
    mutating func removeBest() -> Element?
    
    ///Update element
    mutating func update(newElement: Element)
    
    ///Return element
    subscript(vertex: Element.Vertex) -> Element? {get}
}
extension FinderHeapProtocol {
    ///back trace
    public func backtrace(vertex: Element.Vertex) -> [Element.Vertex] {
        var result = [vertex];
        var element: Element? = self[vertex];
        repeat{
            guard let parent = element?.parent else {
                break;
            }
            result.append(parent);
            element = self[parent];
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
}

//MARK: FinderExactCostProtocol
public protocol FinderExactCostProtocol {
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Return exact cost from v1 to v2
    func exactCost(from v1: Vertex, to v2: Vertex) -> Int
}

//MARK: FinderHeuristicProtocol
public protocol FinderHeuristicProtocol {
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///heuristic
    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
}



