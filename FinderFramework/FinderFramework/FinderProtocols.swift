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
    
    ///successors around element
    func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)]
    
    ///heap type
    associatedtype Heap: FinderHeap;
    
    ///make heap and insert origin element
    func makeHeap() -> Heap
}
extension FinderProtocol where Heap.Element == FElement<Heap.Vertex> {
    ///find
    public func find<Request: FinderRequest>(request: Request, findOne: ([Heap.Vertex]) -> Void) -> Heap
        where Request.Vertex == Heap.Vertex {
        var heap = makeHeap();
        var request = request
        
        repeat{
            ///get best element
            guard let element = heap.removeBest() else {
                break;
            }
            
            ///search element
            let state = request.search(of: element.vertex);
            if state.found {
                let result = backtrace(element: element, in: heap);
                findOne(result);
            }
            if state.completed{
                break;
            }
            
            ///expand successors
            let _successors = successors(around: element, in: heap);
            for successor in _successors{
                let isOpened = successor.isOpened;
                let ele = successor.element;
                isOpened ? heap.update(ele) : heap.insert(ele);
            }
        }while true
        return heap;
    }
    
    ///back trace
    func backtrace(element: Heap.Element, in heap: Heap) -> [Heap.Vertex] {
        var result = [element.vertex];
        var element: Heap.Element = element;
        repeat {
            guard let p = element.parent, let ele = heap.elementOf(p) else {
                break;
            }
            result.append(p);
            element = ele;
        }while true
        return result.reversed();
    }
}

//MARK: FinderOneToOne
public protocol FinderOneToOne{
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///goal
    var goal: Vertex{get}
}
extension FinderOneToOne where Self: FinderProtocol, Self.Vertex == Self.Heap.Vertex, Self.Heap.Element == FElement<Vertex> {
    ////find
    public func find(findOne: ([Vertex]) -> Void) -> Heap {
        let request = FRequestOneToOne<Vertex>.init(goal: goal);
        return self.find(request: request, findOne: findOne);
    }
}


//MARK: FinderManyToOne
public protocol FinderManyToOne {
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///goals
    var goals: [Vertex]{get}
}
extension FinderManyToOne where Self: FinderProtocol, Self.Vertex == Self.Heap.Vertex, Self.Heap.Element == FElement<Vertex> {
    ////find
    public func find(findOne: ([Vertex]) -> Void) -> Heap {
        if(goals.count > 1){
            let request = FRequestManyToOne<Vertex>.init(goals: goals);
            return self.find(request: request, findOne: findOne);
        }
        else {
            let request = FRequestOneToOne<Vertex>.init(goal: goals[0]);
            return self.find(request: request, findOne: findOne);
        }
    }
}


//MARK: FinderHeap
public protocol FinderHeap {
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Element Type
    associatedtype Element = FElement<Vertex>;
    
    ///Insert a element into 'Self'.
    mutating func insert(_ element: Element)
    
    ///Remove the best element and close it.
    mutating func removeBest() -> Element?
    
    ///Update element
    mutating func update(_ newElement: Element)
    
    ///Return element info
    func elementOf(_ vertex: Vertex) -> Element?
}




//MARK: FinderRequest
public protocol FinderRequest {
    ///vertex type
    associatedtype Vertex: Hashable;
    
    ///vertex is one of targets
    mutating func search(of vertex: Vertex) -> (found: Bool, completed: Bool)
}




//public struct BreadthBestFinder<Vertex: Hashable> {
//    
//    var origin: Vertex;
//    
//    var goal: Vertex;
//    
//    public var isComplete: Bool = false;
//    
//    init(origin: Vertex, goal: Vertex) {
//        self.origin = origin;
//        self.goal = goal;
//    }
//    
//    
//    
//}
//extension BreadthBestFinder: FinderProtocol {
//    
//    public typealias Heap = FHeap<Vertex>;
//    
//    public func makeHeap() ->  Heap{
//        let ele = Heap.Element(vertex: origin, parent: .none, g: 0, h: 0);
//        var heap = Heap();
//        heap.insert(ele);
//        return heap;
//    }
//    
//    public mutating func search(element: Heap.Element) -> Bool {
//        guard  element.vertex == goal else {
//            return false;
//        }
//        isComplete = true;
//        return true;
//    }
//    
//    public func successors(of element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
//        var result: [(element: Heap.Element, isOpened: Bool)] = [];
//        let neighbors: [Heap.Vertex] = []; //test
//        let parentVertex = element.vertex;
//        var g = element.g;
//        for n in neighbors{
//            if let _ = heap.elementOf(n){
//                continue;
//            }
//            g += 1;
//            let ele = Heap.Element(vertex: n, parent: parentVertex, g: g, h: 0);
//            result.append((ele, false));
//        }
//        return result;
//    }
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
