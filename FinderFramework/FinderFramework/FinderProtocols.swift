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
    
    ///Return successor elements around element
    func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)]
}
extension FinderProtocol{
    
    ///find
    public func find<Request>(request: Request, findOne: ([Heap.Element.Vertex]) -> Void) -> Heap where
        Request: FinderRequestProtocol,
        Request.Vertex == Self.Heap.Element.Vertex
    {
        var request = request;
        var heap = self.makeHeap();
        
        repeat {
            //get best element
            guard let element = heap.removeBest() else {
                break;
            }
            let vertex = element.vertex;
            
            //check state
            let state = request.search(of: vertex);
            if state.found{
                let result = heap.backtrace(vertex: vertex);
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
                !isOpened ? heap.insert(ele) : heap.update(ele);
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
    mutating func insert(_ element: Element)
    
    ///Remove the best element and close it.
    mutating func removeBest() -> Element?
    
    ///Update element
    mutating func update(_ newElement: Element)
    
    ///Return element info
    func elementOf(_ vertex: Element.Vertex) -> Element?
}
extension FinderHeapProtocol {
    ///back trace
    public func backtrace(vertex: Element.Vertex) -> [Element.Vertex] {
        var result = [vertex];
        var element: Element? = elementOf(vertex);
        repeat{
            guard let parent = element?.parent else {
                break;
            }
            result.append(parent);
            element = elementOf(parent);
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

//MARK: FinderRequestProtocol
public protocol FinderRequestProtocol {
    ///vertex type
    associatedtype Vertex: Hashable;
    
    ///origin vertex
    var origin: Vertex{get}
    
    ///vertex is one of targets
    mutating func search(of vertex: Vertex) -> (found: Bool, completed: Bool)
}

//MARK: FinderOneToOne
public protocol FinderOneToOneProtocol{
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///goal
    var goal: Vertex{get}
    
    ///origin
    var origin: Vertex{get}
}
extension FinderOneToOneProtocol
    where
    Self: FinderProtocol,
    Self.Vertex == Self.Heap.Element.Vertex
{
    ////find
    public func find(findOne: ([Vertex]) -> Void) -> Heap {
        let request = FRequestOneToOne<Vertex>.init(origin: origin, goal: goal);
        return self.find(request: request){
            let result: [Vertex] = $0.reversed();
            findOne(result);
        }
    }
}


//MARK: FinderManyToOne
public protocol FinderManyToOneProtocol {
    ///Vertex type
    associatedtype Vertex: Hashable;
    
    ///origin
    var origin: Vertex{get}
    
    ///goals
    var goals: [Vertex]{get}
}
extension FinderManyToOneProtocol
    where
    Self: FinderProtocol,
    Self.Vertex == Self.Heap.Element.Vertex
{
    ////find
    public func find(findOne: ([Vertex]) -> Void) -> Heap {
        if(goals.count > 1){
            let request = FRequestManyToOne<Vertex>.init(origin: origin, goals: goals);
            return self.find(request: request, findOne: findOne);
        }
        else {
            let request = FRequestOneToOne<Vertex>.init(origin: origin, goal: goals[0]);
            return self.find(request: request, findOne: findOne);
        }
    }
}







