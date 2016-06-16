//
//  Finder2.swift
//  FinderFramework
//
//  Created by 173 on 16/1/14.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: == FinderPointable ==
public protocol FinderPointable: Comparable {
    
    ///point type
    typealias Point: Hashable;
    
    ///'self' point
    var point: Point {get}
    
    ///parent point
    var parent: Point? {get}
}

//MARK: == FinderQueueType ==
public protocol FinderQueueType {
    ///element type
    typealias Element: FinderPointable;
    
    ///Pop best element
    /// - Requires: set element closed
    mutating func pop() -> Element?
    
    ///Push element and store
    /// - Requires: set element visited
    mutating func push(element: Element)
    
    ///Replace element (at element.point)
    mutating func replace(element: Element)
    
    ///Return (element, closed) at point; point is visited return visited (element, closed) otherwise return nil
    func elementOf(point: Element.Point) -> (Element, Bool)?
}
extension FinderQueueType {
    ///Return point chian of element
    @warn_unused_result
    public final func pointChainOf(element: Element) -> [Element.Point]{
        let point = element.point;
        var result: [Element.Point] = [point]
        var e = element;
        repeat{
            guard let p = e.parent else{break;}
            result.append(p);
            guard let be = self.elementOf(p) else {break;}
            e = be.0;
        }while true;
        return result;
    }
}





//MARK: == FinderQueue ==
public struct FinderQueue<Element: FinderPointable> {
    ///open list
    public private(set) var openList: PriorityQueue<Element>;
    
    ///visite list
    public private(set) var visiteList: [Element.Point: Element];
    
    ///closed list
    public private(set) var closedList: [Element.Point: Element];
    
    ///init
    public init(){
        self.openList = PriorityQueue.init(minimum: []);
        self.visiteList = [:];
        self.closedList = [:];
    }
    
    ///backtrace record
    public func backtraceRecord() -> [Element] {
        return visiteList.values.reverse() + closedList.values.reverse();
    }
}
extension FinderQueue: FinderQueueType{
    ///get the visited element and return it, or nil if no visited element exists at point.
    ///return (visited element, is closed)
    public func elementOf(point: Element.Point) -> (Element, Bool)? {
        if let e = self.visiteList[point] {
            return (e, false);
        }
        
        if let e = self.closedList[point] {
            return (e, true);
        }
        
        return .None;
    }
    
    ///return next element
    /// - Requires: set element closed
    mutating public func pop() -> Element?{
        guard let element = self.openList.popBest() else {return .None;}
        self.visiteList.removeValueForKey(element.point);
        self.closedList[element.point] = element;
        return element;
    }
    
    ///insert element and set element visited
    mutating public func push(element: Element){
        self.openList.insert(element);
        self.visiteList[element.point] = element;
    }
    
    ///update element
    mutating public func replace(element: Element) {
        print("WARN: FinderDelegate.update ===============")
        guard let i = (self.openList.indexOf{$0 == element}) else {return;}
        self.openList.replace(i, newValue: element)
        self.visiteList[element.point] = element;
    }
}

//MARK: == FinderDiagonalModel ==
public enum FinderDiagonalModel {
    case Never          //just straight
    case Always         //straight and diagonal without check obstacle
    case NoObstacle     //straight and diagonal whth check if all straight neighbors is not obstacle
    case MostOneNoObstacle      //straight and diagonal with check if has one neighbor which is not obstacle at least;
}






/**


Diagonal model -> always(diagonal), never(straight), no obstacles(diagonal), one obstacle(diagoanl)


generate:
current point
parent element
visisted element
cost
h       -- required goal    *

find:
queue
neighbors
istarget    *
isterminal  *

**/
///