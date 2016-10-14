//
//  temp.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/10/12.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation



//public struct FinderJPS<T: FinderJumpable> {
//
//    public typealias Vertex = T.Vertex;
//
//    public typealias Element = FinderElement<Vertex>;
//
//    public typealias Record = FinderRecord<Vertex, Element>;
//
//    public fileprivate(set) var record: Record;
//
//    fileprivate(set) var heap: PriorityQueue<Element>;
//
//    let jumpable: T;
//
//    public init(jumpable: T) {
//        self.jumpable = jumpable;
//        self.record = Record();
//        self.heap = PriorityQueue<Element>.init(isOrderedBefore: {
//            return $0.f < $1.f ? true : ($0.h < $1.h);
//        });
//    }
//
//    fileprivate mutating func expanding(around element: Element, hueristic: (Vertex) -> Int) {
//        let parentVertex = element.vertex;
//        for successor in jumpable.successors(around: parentVertex) {
//            guard let _successor = jumpable.jump(vertex: successor, from: parentVertex) else {
//                continue;
//            }
//
//            if record.value(isClosed: _successor) != nil{
//                continue;
//            }
//
//            let g = element.g + jumpable.heuristic(from: parentVertex, to: _successor);
//            guard var opened = record.value(isOpened: _successor) else {
//                let h = hueristic(_successor);
//                let ele = Element(vertex: _successor, parent: parentVertex, g: g, h: h);
//                heap.insert(ele);
//                record.openValue(ele, forKey: _successor);
//                continue;
//            }
//
//            if g < opened.g , let i = heap.index(of: opened) {
//                opened.update(parentVertex, g: g);
//                heap.updateElement(opened, atIndex: i);
//                record.openValue(opened, forKey: _successor);
//            }
//        }
//    }
//
//    public mutating func find(target: Vertex, from origin: Vertex) -> [Vertex]?{
//        let originElement = Element(vertex: origin, parent: nil);
//        heap.insert(originElement);
//        repeat {
//            guard let e = heap.popBest() else {
//                break;
//            }
//            let v = e.vertex;
//            record.closeValue(e, forKey: v);
//            if v == target {
//                return record.backtrace(of: v).reversed();
//            }
//            expanding(around: e){
//                return jumpable.heuristic(from: $0, to: target);
//            };
//
//        }while true
//        return nil;
//    }
//
//
//    public mutating func find(target: Vertex, from vertexs: [Vertex]) -> [[Vertex]]{
//        var result: [[Vertex]] = [];
//        let originElement = Element(vertex: target, parent: nil);
//        heap.insert(originElement);
//        var vertexs = vertexs;
//        repeat {
//            guard let e = heap.popBest() else {
//                break;
//            }
//
//            let v = e.vertex;
//            record.closeValue(e, forKey: v);
//
//            if let i = vertexs.index(of: v) {
//                result.append(record.backtrace(of: v));
//                vertexs.remove(at: i);
//                if vertexs.isEmpty{
//                    break;
//                }
//            }
//
//            expanding(around: e){_ in
//                return 0;
//            }
//        }while true
//        return result;
//    }
//}
