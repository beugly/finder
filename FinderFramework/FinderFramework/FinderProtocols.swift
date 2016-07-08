//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation





////MARK:: == FinderProtocol ==
//public protocol FinderProtocol {
//    
//    ///Point Type
//    associatedtype Point: Hashable;
//    
//    ///Heap Type
//    associatedtype Heap: FinderHeapType;
//    
//    ///Priority queue
//    var heap: Heap {get set}
//    
//    ///Return 'Point's around 'Heap.Element'
//    func getPointsAround(element: Heap.Element) -> [Point]
//    
//    ///Check 'Point' around 'Heap.Element'
//    ///If point is closed or illegal return nil
//    ///Otherwise Return(element, opend state)
//    func checkPoint(point: Point, around: Heap.Element?) -> (element: Heap.Element, opened: Bool)?
//    
//    ///Parse element Return result of element
//    func parseElement(ele: Heap.Element) -> (target: Point, result: [Point])
//    
//    ///Return true if element is one of target 
//    ///Return false if element is not one of target
//    ///Return nil if finding is ternimal
//    mutating func isTarget(ofElement: Heap.Element) -> Bool?
//    
//}
//extension FinderProtocol {
//    ///Find
//    ///Return result
//    final mutating func find(origin: Point) -> [Point: [Point]] {
//        var result: [Point: [Point]] = [:];
//        if let item = self.checkPoint(origin, around: .None) {
//            !item.opened ? self.heap.push(item.element) : self.heap.update(item.element);
//        }
//        repeat {
//            guard let
//                element = self.heap.pop(),
//                flag = self.isTarget(element)
//                else{break;}
//            
//            if(flag) {
//                let r = self.parseElement(element);
//                result[r.target] = r.result;
//            }
//            
//            self.getPointsAround(element).forEach{
//                if let item = self.checkPoint($0, around: element) {
//                    !item.opened ? self.heap.push(item.element) : self.heap.update(item.element);
//                }
//            }
//        }while true;
//        return result;
//    }
//}




