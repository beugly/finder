//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation




//MARK: FinderProtocol
public protocol FinderProtocol{
    
    ///Heap Type
    associatedtype Heap: FinderHeap;
    
    ///is complete
    var isComplete: Bool{get}
    
    ///search element in heap, return vertex array if element is one of goals
    mutating func search(element: Heap.Element) -> Bool
    
    ///make heap
    func makeHeap() -> Heap
    
    ///successors of element which in heap;
    func successors(of element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)]
}
extension FinderProtocol {
    
    ///find
    public mutating func find( findOne: ([Heap.Vertex]) -> Void) -> Heap {
        var heap = makeHeap();
        repeat {
            guard let element = heap.removeBest() else {
                break;
            }
            
            if search(element: element){
                let result = heap.backtrace(element);
                findOne(result);
            }
            
            if isComplete{
                break;
            }
            
            let _successors = successors(of: element, in: heap);
            for successor in _successors{
                successor.isOpened ? heap.update(successor.element) : heap.insert(successor.element);
            }
        }while true
        return heap;
    }
}




public struct BreadthBestFinder<Vertex: Hashable> {
    
    var origin: Vertex;
    
    var goal: Vertex;
    
    public var isComplete: Bool = false;
    
    init(origin: Vertex, goal: Vertex) {
        self.origin = origin;
        self.goal = goal;
    }
    
    
    
}
extension BreadthBestFinder: FinderProtocol {
    
    public typealias Heap = FHeap<Vertex>;
    
    public func makeHeap() ->  Heap{
        let ele = Heap.Element(vertex: origin, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(ele);
        return heap;
    }
    
    public mutating func search(element: Heap.Element) -> Bool {
        guard  element.vertex == goal else {
            return false;
        }
        isComplete = true;
        return true;
    }
    
    public func successors(of element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
        var result: [(element: Heap.Element, isOpened: Bool)] = [];
        let neighbors: [Heap.Vertex] = []; //test
        let parentVertex = element.vertex;
        var g = element.g;
        for n in neighbors{
            if let _ = heap.elementOf(n){
                continue;
            }
            g += 1;
            let ele = Heap.Element(vertex: n, parent: parentVertex, g: g, h: 0);
            result.append((ele, false));
        }
        return result;
    }
}











//public protocol FinderSource {
//
//    ///vertex
//    associatedtype Vertex: Hashable;
//
//    ///neighbors of vertex
//    func neighbors(of vertex: Vertex) -> [Vertex]
//
//    ///Return movement cost from v1 to v2
//    func movementCost(from v1: Vertex, to v2: Vertex) -> Int
//
//    ///Return h value of vertex
//    func heuristic(from v1: Vertex, to v2: Vertex) -> Int
//}










/////FinderAbstract
//public protocol FinderAbstract{
//    
//    ///Vertex Type
//    associatedtype Vertex: Hashable;
//    
//    ///Goal Type
//    associatedtype Goal = Vertex;
//    
//    ///origin
//    var origin: Vertex {get}
//    
//    ///goal
//    var goal: Goal{get set}
//    
//    ///Finder is complete
//    var isComplete: Bool {get set}
//    
//    ///Return vertex is one of goals
//    mutating func isGoal(vertex: Vertex) -> Bool
//    
//    ///Return movement cost from v1 to v2
//    func movementCost(from v1: Vertex, to v2: Vertex) -> Int?
//    
//    ///Return h value of vertex
//    func heuristic(of vertex: Vertex) -> Int
//    
//    ///Return successors of vertex from v
//    func successorsOf(vertex: Vertex, from v: Vertex) -> [Vertex]
//    
//    
//    
//    ///Heap Type
//    associatedtype Heap: FinderHeap;
//}
//extension FinderAbstract {
//    mutating public func isGoal(vertex: Vertex) -> Bool{
//        return false;
//    }
//}
//extension FinderAbstract where Goal == Vertex{
//    ///Return vertex is one of goals
//    mutating public func isGoal(vertex: Vertex) -> Bool{
//        guard vertex == goal else {
//            return false;
//        }
//        isComplete = true;
//        return true;
//    }
//}
//extension FinderAbstract where Goal == [Vertex]{
//    ///Return vertex is one of goals
//    mutating public func isGoal(vertex: Vertex) -> Bool{
//        guard let index = goal.indexOf(vertex) else {
//            return false;
//        }
//        goal.removeAtIndex(index);
//        if goal.isEmpty {
//            isComplete = true;
//        }
//        return true;
//    }
//}
//extension FinderAbstract where Heap.Vertex == Self.Vertex, Heap.Element == FElement<Vertex> {
//    
//    ///execute
//    mutating public func execute(@noescape findOne: [Vertex] -> Void) -> Heap{
//        var storage = Heap();
//        let h = heuristic(of: origin);
//        let originEle = FElement<Vertex>(vertex: origin, parent: nil, g: 0, h: h);
//        storage.insert(originEle);
//        
//        repeat{
//            guard let element = storage.removeBest() else {
//                break;
//            }
//            
//            let vertex = element.vertex;
//            if isGoal(vertex) {
//                let result = storage.backtrace(vertex);
//                findOne(result);
//            }
//            
//            if isComplete{
//                break;
//            }
//            
//            let parentVertex = element.parent ?? vertex;
//            let successors = successorsOf(vertex, from: parentVertex);
//            for successor in successors {
//                guard let cost = movementCost(from: vertex, to: successor) else {
//                    return;
//                }
//                
//                let g = cost + element.g;
//                if let old = storage.elementOf(successor) where !old.isClosed && old.g > g{
//                    var newElement = old;
//                    newElement.g = g;
//                    newElement.parent = vertex;
//                    storage.update(newElement);
//                    return;
//                }
//                
//                let h = heuristic(of: successor);
//                let ele = FElement<Vertex>(vertex: successor, parent: vertex, g: g, h: h);
//                storage.insert(ele);
//            }
//        }while true
//        return storage;
//    }
//}
