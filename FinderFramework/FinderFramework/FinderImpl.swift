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
    public let start, goal: Option.Vertex, option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderDijkstra: FinderOneToOne{}
extension FinderDijkstra: FinderProtocol {
    public func expandSuccessors(around element: FinderElement<Option.Vertex>, into heap: inout FinderHeap<Option.Vertex>) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.element(of: succssor) {
                guard !visited.isClosed && g < visited.g else {
                    continue;
                }
                let ele = FinderElement(vertex: succssor, parent: vertex, g: g, h: visited.h);
                heap.update(newElement: ele);
            }
            else {
                let ele = FinderElement(vertex: succssor, parent: vertex, g: g, h: 0);
                heap.insert(element: ele);
            }
        }
    }
}

//MARK: FinderGreedyBest
public struct FinderGreedyBest<Option> where Option: FinderOptionProtocol {
    public let start, goal: Option.Vertex, option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderGreedyBest: FinderOneToOne{}
extension FinderGreedyBest: FinderProtocol {
    public func expandSuccessors(around element: FinderElement<Option.Vertex>, into heap: inout FinderHeap<Option.Vertex>) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            guard let _ = heap.element(of: succssor) else {
                continue;
            }
            let h = option.heuristic(from: vertex, to: goal);
            let ele = FinderElement(vertex: succssor, parent: vertex, g: 0, h: h);
            heap.insert(element: ele);
        }
    }
}


//MARK: FinderAStar
public struct FinderAStar<Option> where Option: FinderOptionProtocol {
    public let start, goal: Option.Vertex, option: Option;
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderAStar: FinderOneToOne{}
extension FinderAStar: FinderProtocol {
    public func expandSuccessors(around element: FinderElement<Option.Vertex>, into heap: inout FinderHeap<Option.Vertex>) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.element(of: succssor) {
                guard !visited.isClosed && g < visited.g else {
                    continue;
                }
                let ele = FinderElement(vertex: succssor, parent: vertex, g: g, h: visited.h);
                heap.update(newElement: ele);
            }
            else {
                let h = option.heuristic(from: vertex, to: goal);
                let ele = FinderElement(vertex: succssor, parent: vertex, g: g, h: h);
                heap.insert(element: ele);
            }
        }
    }
}


//MARK: FinderBFS
public class FinderBFS<Option> where Option: FinderOptionProtocol {
    public let starts: [Option.Vertex];
    public let goal: Option.Vertex;
    public let option: Option;
    fileprivate var _starts: [Option.Vertex];
    public init(starts: [Option.Vertex], goal: Option.Vertex, option: Option) {
        self.starts = starts;
        self.goal = goal;
        self.option = option;
        self._starts = starts;
    }
}
extension FinderBFS {
    ///static find
    public static func find(from vertexs: [Option.Vertex], to vertex: Option.Vertex, option: Option) -> [[Option.Vertex]] {
        var result: [[Option.Vertex]] = [];
        let f = FinderBFS.init(starts: vertexs, goal: vertex, option: option);
        let _ = f.find{
            result.append($0);
        }
        return result;
    }
}
extension FinderBFS: FinderProtocol {
    public typealias Heap = FinderArray<Option.Vertex>;

    public func expandSuccessors(around element: Heap.Element, into heap: inout Heap) {
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        var i = 0;
        for succssor in _successors {
            i += 1;
            guard let _ = heap.element(of: succssor) else {
                continue;
            }
            let g = element.g + i;
            let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: 0);
            heap.insert(element: ele);
        }
    }
    
    ///find
    public func find(findOne: ([Option.Vertex]) -> Void) -> Heap{
        self._starts = starts;
        let origin = Heap.Element(vertex: goal, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        repeat {
            //get best element
            guard let element = heap.next() else {
                break;
            }

            //check state
            let vertex = element.vertex;
            if let i = _starts.index(of: vertex) {
                _starts.remove(at: i);
                let result: [Option.Vertex] = heap.backtrace(of: vertex)
                findOne(result);
                if _starts.isEmpty {
                    break;
                }
            }

            //expand successors
            expandSuccessors(around: element, into: &heap);
        }while true
        return heap;
    }
}


//MARK: FinderElement
public struct FinderElement<Vertex: Hashable> {
    ///properties
    public let vertex: Vertex, parent: Vertex?,     ///vertex, parent vertex
    g, h, f: Int;                                   ///exact cost, h: estimate cost, f: g + h
    
    ///is closed
    public fileprivate(set) var isClosed: Bool;
    
    ///init
    public init(vertex: Vertex, parent: Vertex?, g: Int, h: Int, isClosed: Bool = false){
        self.vertex = vertex;
        self.parent = parent;
        self.g = g;
        self.h = h;
        self.f = g + h;
        self.isClosed = isClosed;
    }
}
extension FinderElement: Comparable {}
public func ==<Vertex: Hashable>(lsh: FinderElement<Vertex>, rsh: FinderElement<Vertex>) -> Bool{
    return lsh.vertex == rsh.vertex;
}
public func <<Vertex: Hashable>(lsh: FinderElement<Vertex>, rsh: FinderElement<Vertex>) -> Bool{
    return lsh.f < rsh.f ? true : (lsh.h < rsh.h);
}


//MARK: FinderHeap
public struct FinderHeap<T: Hashable> {
    ///Open list
    internal fileprivate(set) var openList: PriorityQueue<Element>;
    
    ///Visited list - [Vertex: Element]
    internal fileprivate(set) var visitList: [T: Element];
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<Element>(minimum: 2);
    }
}
extension FinderHeap: FinderOpenListProtocol {
    public typealias Element = FinderElement<T>;
    
    public mutating func next() -> Element? {
        guard let element = openList.popBest() else {
            return .none;
        }
        visitList[element.vertex]?.isClosed = true;
        return element;
    }
    ///return visited element of vertex
    public func element(of vertex: T) -> Element? {
        return visitList[vertex];
    }
}
extension FinderHeap {
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.insert(element: element);
        visitList[element.vertex] = element;
    }
    
    ///Update element
    mutating public func update(newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.index{$0.vertex == vertex}) else {
            return;
        }
        openList.replace(newValue: newElement, at: index);
        visitList[vertex] = newElement;
    }
}

//MARK: FinderArray
public struct FinderArray<T: Hashable> {
    ///Open list
    internal fileprivate(set) var openList: [Element];
    
    ///Visited list - [Vertex: Element]
    internal fileprivate(set) var visitList: [T: Element];
    
    ///current index
    fileprivate var currentIndex = 0;
    
    ///Init
    public init(){
        self.visitList = [:];
        self.openList = [];
    }
}
extension FinderArray: FinderOpenListProtocol {
    ///Element Type
    public typealias Element = FinderElement<T>;
    
    public mutating func next() -> Element? {
        guard currentIndex < openList.count else {
            return nil;
        }
        
        let ele = openList[currentIndex];
        visitList[ele.vertex]?.isClosed = true;
        currentIndex += 1;
        return ele;
    }
    ///return visited element of vertex
    public func element(of vertex: T) -> Element? {
        return visitList[vertex];
    }
}
extension FinderArray {
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.append(element);
        visitList[element.vertex] = element;
    }
    
    ///Update element
    mutating public func update(newElement: Element) {
        let vertex = newElement.vertex;
        guard let index = (openList.index{$0.vertex == vertex}) else {
            return;
        }
        openList[index] = newElement;
        visitList[vertex] = newElement;
    }
}

