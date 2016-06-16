//
//  Finder3.swift
//  FinderFramework
//
//  Created by 173 on 16/2/16.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation




//MARK:: == FinderPriorityQueueType ==
public protocol FinderPriorityQueueType {
    
    ///Element
    typealias Element;
    
    ///Point
    typealias Point;
    
    ///Insert element
    mutating func insert(element: Element)
    
    ///Pop best element(close it)
    mutating func popBest() -> Element?
    
    ///Return element at point
    func getElement(at point: Point) -> Element?
    
    ///Return point of element
    func getPoint(of element: Element) -> Point;
}
extension FinderPriorityQueueType where Self.Point == Self.Element{
    ///Return point of element
    public func pointOf(element: Element) -> Point{
        return element;
    }
}


//MARK:: == FinderDataSourceType ==
public protocol FinderDataSourceType {
    
    ///Point type
    typealias Point;
    
    ///Return valid point touple, (point, cost)
    func neighborsOf(point: Point) -> (p: Point, cost: Int)
}
















