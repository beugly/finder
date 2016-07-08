//
//  FinderCore.swift
//  FinderFramework
//
//  Created by xifangame on 16/7/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


///FinderHeapType
public protocol FinderHeapType {
    
    ///Point Type
    associatedtype Point: Hashable;
    
    ///Return visited
    func visitedOf(point: Point) -> Visited?
    
    ///insert element
    mutating func insert(element: Element, parent: Element?)
    
    ///pop element and set it closed
    mutating func pop() -> Element?
    
    ///update element
    mutating func update(newValue: Visited)
}
extension FinderHeapType {
    
    ///Element Type
    public typealias Element = FinderElement<Self.Point>;
    
    ///Visited type
    public typealias Visited = (element: Element, parent: Element?, closed: Bool)
    
    ///back trace element
    public func backtrace(point: Point) -> [Element] {
        guard let element = visitedOf(point)?.element else {
            return [];
        }
        
        var result = [element];
        var point = point;
        
        repeat{
            guard let parent = visitedOf(point)?.parent else {
                return result;
            }
            result.append(parent);
            point = parent.point;
        }while true;
    }
    
    ///back trace element
    public func backtrace(point: Point) -> [Point] {
        let result: [Element] = backtrace(point);
        return result.flatMap{
            return $0.point;
        }
    }
}


///FinderHeap
public struct FinderHeap<T: Hashable> {
    
    ///openlist
    public private(set) var openList: PriorityQueue<FinderHeap.Element>;
    
    ///visitlist - [Point: Visited]
    public private(set) var visitList: [Point: FinderHeap.Visited];
    
    ///init
    public init(){
        self.visitList = [:];
        self.openList = PriorityQueue<FinderHeap.Element>{
            $0.f < $1.f;
        }
    }
}
extension FinderHeap: FinderHeapType {
    
    ///Point Type
    public typealias Point = T;
    
    public func visitedOf(point: Point) -> FinderHeap.Visited? {
        return visitList[point];
    }
    
    public mutating func insert(element: FinderHeap.Element, parent: FinderHeap.Element?) {
        openList.insert(element);
        visitList[element.point] = (element: element, parent: parent, closed: false);
    }
    
    public mutating func pop() -> FinderHeap.Element? {
        guard let element = openList.popBest() else {
            return .None;
        }
        visitList[element.point]?.closed = true;
        return element;
    }
    
    public mutating func update(newValue: FinderHeap.Visited) {
        let point = newValue.element.point;
        guard let index = (openList.indexOf{$0.point == point}) else {
            return;
        }
        openList.replace(index, newValue: newValue.element);
        visitList[point] = newValue;
    }
}


///FinderElement
public struct FinderElement<Point: Hashable> {
    
    ///point
    public let point: Point;
    
    ///g value real cost, h value   
    public internal(set) var g, h: Int;
    
    ///f value, f = g + h;
    public var f: Int {
        return g + h;
    }
    
    ///init
    public init(point: Point, g: Int, h: Int){
        self.point = point;
        self.g = g;
        self.h = h;
    }
}


