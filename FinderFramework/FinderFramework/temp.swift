//
//  temp.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/10/12.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//extension FinderBFS {
//    public static func find<S>(from v1: Vertex, to v2: Vertex, successors: S) -> [Vertex]?
//        where S: FinderSuccessorsProtocol, S.Vertex == Vertex
//    {
//        var result: [Vertex]? = nil;
//        var engine = FinderBFS<S.Vertex>();
//        engine.insert((v2, nil));
//        
//        repeat {
//            guard let element = engine.popBest() else {
//                break;
//            }
//            
//            let vertex = element.vertex;
//            if vertex == v1 {
//                result = engine.backtrace(of: vertex);
//                break;
//            }
//            
//            for successor in successors.successors(around: vertex) {
//                if engine.element(of: successor) == nil {
//                    engine.insert((successor, vertex));
//                }
//            }
//        }while true
//        return result;
//    }
//    
//    
//    public static func find<S>(from vertexs: [Vertex], to vertex: Vertex, successors: S) -> [[Vertex]]
//        where S: FinderSuccessorsProtocol, S.Vertex == Vertex
//    {
//        var result: [[Vertex]] = [];
//        
//        ///one
//        if vertexs.count == 1 {
//            let v1 = vertexs[0];
//            if let r = find(from: v1, to: vertex, successors: successors) {
//                result.append(r);
//            }
//            return result;
//        }
//        
//        ///more
//        var vertexs = vertexs;
//        var engine = FinderBFS<S.Vertex>();
//        engine.insert((vertex, nil));
//        
//        repeat {
//            guard let element = engine.popBest() else {
//                break;
//            }
//            
//            let v = element.vertex;
//            if let i = vertexs.index(of: v) {
//                let r = engine.backtrace(of: v);
//                result.append(r);
//                vertexs.remove(at: i);
//            }
//            if vertexs.isEmpty {
//                break;
//            }
//            
//            for successor in successors.successors(around: v) {
//                if engine.element(of: successor) == nil {
//                    engine.insert((successor, v));
//                }
//            }
//        }while true
//        return result;
//    }
//    
//    
//    
//    //    public static func findJPS<S>(from v1: Vertex, to v2: Vertex, successors: S) -> [Vertex]?
//    //        where S: FinderSuccessorsProtocol & FinderUniformCostProtocol & FinderOptionProtocol, S.Vertex == Vertex
//    //    {
//    //
//    //        if !successors.jumpable {
//    //            return find(from: v1, to: v2, successors: successors);
//    //        }
//    //
//    //        var result: [Vertex]? = nil;
//    //        var engine = FinderHeap<Vertex>();
//    //        let origin = FinderElement(vertex: v2, parent: nil, g: 0, h: 0);
//    //        engine.insert(origin);
//    //
//    //        repeat {
//    //            guard let element = engine.popBest() else {
//    //                break;
//    //            }
//    //
//    //            let vertex = element.vertex;
//    //            if vertex == v1 {
//    //                result = engine.backtrace(of: vertex);
//    //                break;
//    //            }
//    //
//    //            for successor in successors.successors(around: vertex) {
//    //                guard let successor = successors.jump(vertex: successor, from: vertex) else {
//    //                    continue;
//    //                }
//    //                let g = element.g + successors.heuristic(from: vertex, to: successor);
//    //                if let old = engine.element(of: successor) {
//    //                    if !old.isClosed && old.g > g {
//    //                        let ele = FinderElement(vertex: successor, parent: vertex, g: g, h: old.h);
//    //                        let _ = engine.update(ele);
//    //                    }
//    //                }
//    //                else {
//    //                    let h = successors.heuristic(from: successor, to: v1);
//    //                    let ele = FinderElement(vertex: successor, parent: vertex, g: g, h: h);
//    //                    engine.insert(ele);
//    //                }
//    //            }
//    //        }while true
//    //        return result;
//    //    }
//    //
//    //
//    //
//    //    public static func findJPS<S>(from vertexs: [Vertex], to vertex: Vertex, successors: S) -> [[Vertex]]
//    //        where S: FinderSuccessorsProtocol & FinderUniformCostProtocol & FinderOptionProtocol, S.Vertex == Vertex
//    //    {
//    //
//    //        if !successors.jumpable {
//    //            return find(from: vertexs, to: vertex, successors: successors);
//    //        }
//    //
//    //        var result: [[Vertex]] = [];
//    //
//    //        ///one
//    //        if vertexs.count == 1 {
//    //            let v1 = vertexs[0];
//    //            if let r = findJPS(from: v1, to: vertex, successors: successors) {
//    //                result.append(r);
//    //            }
//    //            return result;
//    //        }
//    //
//    //        ///more
//    //        var vertexs = vertexs;
//    //        var engine = FinderHeap<Vertex>();
//    //        let origin = FinderElement(vertex: vertex, parent: nil, g: 0, h: 0);
//    //        engine.insert(origin);
//    //
//    //        repeat {
//    //            guard let element = engine.popBest() else {
//    //                break;
//    //            }
//    //
//    //            let v = element.vertex;
//    //            if let i = vertexs.index(of: v) {
//    //                let r = engine.backtrace(of: v);
//    //                result.append(r);
//    //                vertexs.remove(at: i);
//    //            }
//    //            if vertexs.isEmpty {
//    //                break;
//    //            }
//    //
//    //            for successor in successors.successors(around: v) {
//    //                guard let successor = successors.jump(vertex: successor, from: vertex) else {
//    //                    continue;
//    //                }
//    //                let g = element.g + successors.heuristic(from: vertex, to: successor);
//    //                if let old = engine.element(of: successor) {
//    //                    if !old.isClosed && old.g > g {
//    //                        let ele = FinderElement(vertex: successor, parent: v, g: g, h: old.h);
//    //                        let _ = engine.update(ele);
//    //                    }
//    //                }
//    //                else {
//    //                    let ele = FinderElement(vertex: successor, parent: v, g: g, h: 0);
//    //                    engine.insert(ele);
//    //                }
//    //            }
//    //        }while true
//    //        return result;
//    //    }
//}
