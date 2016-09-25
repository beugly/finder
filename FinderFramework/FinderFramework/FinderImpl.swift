//
//  FinderImpl.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//MARK: FinderDijkstra
public struct FinderDijkstra<Option> where Option: FinderOptionProtocol, Option: FinderExactCostProtocol {
    
    public let start: Option.Vertex;
    
    public let goal: Option.Vertex;
    
    public let option: Option;
    
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderDijkstra: FinderProtocol {
    
    public typealias Heap = FinderHeap<Option.Vertex>;
    
    public func makeHeap() -> Heap {
        let origin = Heap.Element(vertex: start, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
    
    public func search(element: Heap.Element) -> (found: Bool, completed: Bool) {
        guard element.vertex == goal else {
            return (false, false);
        }
        return (true, true);
    }
    
    public func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
        var result: [(element: Heap.Element, isOpened: Bool)] = [];
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.visitedOf(vertex: succssor) {
                guard !visited.isClosed && g < visited.element.g else {
                    continue;
                }
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: visited.element.h);
                result.append((ele, true));
            }
            else {
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: 0);
                result.append((ele, false));
            }
        }
        return result;
    }
}


//MARK: FinderBFS
public class FinderBFS<Option> where Option: FinderOptionProtocol {
    
    public let start: Option.Vertex;
    
    public let goals: [Option.Vertex];
    
    public let option: Option;
    
    public init(start: Option.Vertex, goals: [Option.Vertex], option: Option) {
        self.start = start;
        self.goals = goals;
        self.option = option;
        self._goals = goals;
    }
    
    fileprivate var _goals: [Option.Vertex];
}
extension FinderBFS: FinderProtocol {
    
    public typealias Heap = FinderHeap<Option.Vertex>;
    
    public func makeHeap() -> Heap {
        self._goals = goals;
        let origin = Heap.Element(vertex: start, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
    
    public func search(element: Heap.Element) -> (found: Bool, completed: Bool) {
        guard let i = _goals.index(of: element.vertex) else {
            return (false, false);
        }
        _goals.remove(at: i);
        return (true, _goals.isEmpty);
    }
    
    public func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
        var result: [(element: Heap.Element, isOpened: Bool)] = [];
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
            result.append((ele, false));
        }
        return result;
    }
}


//MARK: FinderGreedyBest
public struct FinderGreedyBest<Option> where Option: FinderOptionProtocol, Option: FinderHeuristicProtocol {
    
    public let start: Option.Vertex;
    
    public let goal: Option.Vertex;
    
    public let option: Option;
    
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderGreedyBest: FinderProtocol {
    
    public typealias Heap = FinderHeap<Option.Vertex>;
    
    public func makeHeap() -> Heap {
        let origin = Heap.Element(vertex: start, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
    
    public func search(element: Heap.Element) -> (found: Bool, completed: Bool) {
        guard element.vertex == goal else {
            return (false, false);
        }
        return (true, true);
    }
    
    public func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
        var result: [(element: Heap.Element, isOpened: Bool)] = [];
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            guard let _ = heap.visitedOf(vertex: succssor) else {
                continue;
            }
            let h = option.heuristic(from: vertex, to: goal);
            let ele = Heap.Element(vertex: succssor, parent: vertex, g: 0, h: h);
            result.append((ele, false));
        }
        return result;
    }
}


//MARK: FinderAStar
public struct FinderAStar<Option>
    where
    Option: FinderOptionProtocol,
    Option: FinderExactCostProtocol,
    Option: FinderHeuristicProtocol

{
    
    public let start: Option.Vertex;
    
    public let goal: Option.Vertex;
    
    public let option: Option;
    
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
}
extension FinderAStar: FinderProtocol {
    
    public typealias Heap = FinderHeap<Option.Vertex>;
    
    public func makeHeap() -> Heap {
        let origin = Heap.Element(vertex: start, parent: .none, g: 0, h: 0);
        var heap = Heap();
        heap.insert(element: origin);
        return heap;
    }
    
    public func search(element: Heap.Element) -> (found: Bool, completed: Bool) {
        guard element.vertex == goal else {
            return (false, false);
        }
        return (true, true);
    }
    
    public func successors(around element: Heap.Element, in heap: Heap) -> [(element: Heap.Element, isOpened: Bool)] {
        var result: [(element: Heap.Element, isOpened: Bool)] = [];
        let vertex = element.vertex;
        let _successors = option.successors(of: vertex, from: element.parent);
        for succssor in _successors {
            let g = element.g + option.exactCost(from: vertex, to: succssor);
            if let visited = heap.visitedOf(vertex: succssor) {
                guard !visited.isClosed && g < visited.element.g else {
                    continue;
                }
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: visited.element.h);
                result.append((ele, true));
            }
            else {
                let h = option.heuristic(from: vertex, to: goal);
                let ele = Heap.Element(vertex: succssor, parent: vertex, g: g, h: h);
                result.append((ele, false));
            }
        }
        return result;
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
extension FinderHeap: FinderHeapProtocol {
    
    ///Element Type
    public typealias Element = FinderElement<T>;
    
    ///Insert a element into 'Self'.
    mutating public func insert(element: Element) {
        openList.insert(element: element);
        visitList[element.vertex] = (element, false);
    }
    
    ///Remove the best element and close it.
    mutating public func removeBest() -> Element? {
        guard let element = openList.popBest() else {
            return .none;
        }
        visitList[element.vertex]?.1 = true;
        return element;
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
    
    ///return visited element info
    public func visitedOf(vertex: T) -> (element: Element, isClosed: Bool)? {
        return visitList[vertex];
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
    public init(vertex: Vertex, parent: Vertex?) {
        self.init(vertex: vertex, parent: parent, g: 0, h: 0);
    }
    
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
