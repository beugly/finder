//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//MARK: FinderDijkstra
public struct FinderDijkstra<Option> where Option: FinderOptionProtocol {
    public let start, goal: Option.Vertex;
    public let option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderDijkstra: FinderOneToOne{}
extension FinderDijkstra: FinderProtocol {
    public typealias Vertex = Option.Vertex;
    public typealias Heap = FinderHeap<Vertex>;
    public func expandSuccessors(around element: Heap.Element, into heap: inout Heap) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.visitedOf(vertex: succssor) {
                guard !visited.isClosed && g < visited.element.g else {
                    continue;
                }
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: visited.element.h);
                heap.update(newElement: ele);
            }
            else {
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: 0);
                heap.insert(element: ele);
            }
        }
    }
}

//MARK: FinderGreedyBest
public struct FinderGreedyBest<Option> where Option: FinderOptionProtocol {
    public let start, goal: Option.Vertex;
    public let option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderGreedyBest: FinderOneToOne{}
extension FinderGreedyBest: FinderProtocol {
    public typealias Vertex = Option.Vertex;
    public typealias Heap = FinderHeap<Vertex>;
    public func expandSuccessors(around element: Heap.Element, into heap: inout Heap) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            guard let _ = heap.visitedOf(vertex: succssor) else {
                continue;
            }
            let h = option.heuristic(from: vertex, to: goal);
            let ele = Heap.Element(vertex: succssor, parent: vertex, g: 0, h: h);
            heap.insert(element: ele);
        }
    }
}


//MARK: FinderAStar
public struct FinderAStar<Option> where Option: FinderOptionProtocol {
    public let start, goal: Option.Vertex;
    public let option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderAStar: FinderOneToOne{}
extension FinderAStar: FinderProtocol {
    public typealias Vertex = Option.Vertex;
    public typealias Heap = FinderHeap<Vertex>;
    public func expandSuccessors(around element: Heap.Element, into heap: inout Heap) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.visitedOf(vertex: succssor) {
                guard !visited.isClosed && g < visited.element.g else {
                    continue;
                }
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: visited.element.h);
                heap.update(newElement: ele);
            }
            else {
                let h = option.heuristic(from: vertex, to: goal);
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: h);
                heap.insert(element: ele);
            }
        }
    }
}


//MARK: FinderBFS
public class FinderBFS<Option> where Option: FinderOptionProtocol {
    public let start: Option.Vertex;
    public let goals: [Option.Vertex];
    public let option: Option;
    fileprivate var _goals: [Option.Vertex];
    public init(start: Option.Vertex, goals: [Option.Vertex], option: Option) {
        self.start = start;
        self.goals = goals;
        self.option = option;
        self._goals = goals;
    }
}
extension FinderBFS: FinderProtocol {
    public typealias Vertex = Option.Vertex;
    public typealias Heap = FinderHeap<Vertex>;

    public func makeHeap() -> Heap {
        self._goals = goals;
        let origin = Heap.Element(vertex: start, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
    
    public func search(element: Heap.Element, in heap: Heap) -> (result: [Option.Vertex]?, isCompleted: Bool) {
        guard let i = _goals.index(of: element.vertex) else {
            return (nil, false);
        }
        _goals.remove(at: i);
        let result: [Option.Vertex] = heap.backtrace(vertex: element.vertex);
        return (result, _goals.isEmpty);
    }

    public func expandSuccessors(around element: Heap.Element, into heap: inout Heap) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        var i = 0;
        for succssor in _successors {
            i += 1;
            guard let _ = heap.visitedOf(vertex: succssor) else {
                continue;
            }
            let g = element.g + i;
            let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: 0);
            heap.insert(element: ele);
        }
    }
}


//MARK: FinderHeap
public struct FinderHeap<T: Hashable> {
    ///Open list
    internal fileprivate(set) var openList: PriorityQueue<Element>;
    
    ///Visited list - [Vertex: Element]
    internal fileprivate(set) var visitList: [T: (Element, Bool)];
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<Element>(minimum: 2);
    }
}
extension FinderHeap: FinderIteratorProtocl {
    public typealias Element = FinderElement<T>;
    public mutating func next() -> Element? {
        guard let element = openList.popBest() else {
            return .none;
        }
        visitList[element.vertex]?.1 = true;
        return element;
    }
    ///return visited element info
    public func visitedOf(vertex: T) -> (element: Element, isClosed: Bool)? {
        return visitList[vertex];
    }
}
extension FinderHeap {
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.insert(element: element);
        visitList[element.vertex] = (element, false);
    }
    
    ///Update element
    mutating public func update(newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.index{$0.vertex == vertex}) else {
            return;
        }
        openList.replace(newValue: newElement, at: index);
        visitList[vertex] = (newElement, false);
    }
}


//MARK: FinderElement
public struct FinderElement<Vertex: Hashable> {
    ///Vertex
    public let vertex: Vertex;
    
    public private(set) var parent: Vertex?,   //parent vertex
    g, h: Int;                                 //g: exact cost, h: estimate cost
   
    ///f value (g + h)
    public let f: Int;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
    }
}
extension FinderElement: FinderElementProtocol{}
extension FinderElement: Comparable {}
public func ==<Element: FinderElementProtocol>(lsh: Element, rsh: Element) -> Bool{
    return lsh.vertex == rsh.vertex;
}
public func <<Vertex: Hashable>(lsh: FinderElement<Vertex>, rsh: FinderElement<Vertex>) -> Bool{
    return lsh.f < rsh.f ? true : (lsh.h < rsh.h);
}



//MARK: FinderArray
public struct FinderArray<T: Hashable> {
    ///Open list
    internal fileprivate(set) var openList: [Element];
    
    ///Visited list - [Vertex: Element]
    internal fileprivate(set) var visitList: [T: (Element, Bool)];
    
    ///current index
    fileprivate var currentIndex = 0;
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = [];
    }
}
extension FinderArray: FinderIteratorProtocl {
    ///Element Type
    public typealias Element = FinderElement<T>;
    public mutating func next() -> Element? {
        guard currentIndex < openList.count else {
            return nil;
        }
        
        let ele = openList[currentIndex];
        visitList[ele.vertex]?.1 = true;
        currentIndex += 1;
        return ele;
    }
    ///return visited element info
    public func visitedOf(vertex: T) -> (element: Element, isClosed: Bool)? {
        return visitList[vertex];
    }
}
extension FinderArray {
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.append(element);
        visitList[element.vertex] = (element, false);
    }
    
    ///Update element
    mutating public func update(newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.index{$0.vertex == vertex}) else {
            return;
        }
        openList[index] = newElement;
        visitList[vertex] = (newElement, false);
    }
}

