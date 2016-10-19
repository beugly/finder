//
//  FinderImpl2D.swift
//  FinderFramework
//
//  Created by xifangame on 16/9/28.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//public struct FinderVertex2D{
//    
//    fileprivate var x, y: Int;
//    
//    public init(x: Int, y: Int){
//        self.x = x;
//        self.y = y;
//    }
//}
//
////MARK: FinderHeuristic2D
//public enum FinderHeuristic2D {
//    case Manhattan, Euclidean, Octile, Chebyshev, None
//}
//extension FinderHeuristic2D {
//    /// Return huristic cost
//    public func huristic(dx: Int, dy: Int) -> CGFloat {
//        let dx = CGFloat(dx);
//        let dy = CGFloat(dy);
//        var h: CGFloat;
//        switch self{
//        case .Manhattan:
//            h = dx + dy;
//        case .Euclidean:
//            h = sqrt(dx * dx + dy * dy);
//        case .Octile:
//            let f:CGFloat = CGFloat(M_SQRT2) - 1;
//            h = dx < dy ? f * dx + dy : f * dy + dx;
//        case .Chebyshev:
//            h = max(dx, dy);
//        case .None:
//            h = 0;
//        }
//        return h;
//    }
//}
//
//
////MARK: FinderExpandModel2D
//public enum FinderExpandModel2D {
//    case Straight, Diagonal
//}
//extension FinderExpandModel2D {
//    ///Return neighbors
//    public func neighbors(around x: Int, y: Int) -> [(x: Int, y: Int)] {
//        switch self {
//        case .Straight:
//            return [(x - 1, y), (x, y + 1), (x + 1, y), (x, y - 1)];
//        case .Diagonal:
//            return [(x - 1, y), (x, y + 1), (x + 1, y), (x, y - 1), (x - 1, y + 1), (x - 1, y - 1), (x + 1, y - 1), (x + 1, y + 1)];
//        }
//    }
//}
//
//
//public protocol FinderDataSource2D {
//    ///return cost
//    func costOf(x: Int, y: Int) -> Int?
//}
//
//
//public struct FinderOption2D<Source: FinderDataSource2D>{
//    
//    let source: Source;
//    
//    let model: FinderExpandModel2D;
//    
//    let h: FinderHeuristic2D;
//    
//    
//    public typealias Vertex = FinderVertex2D;
//    
//    public init(source: Source, model: FinderExpandModel2D = .Straight, huristic: FinderHeuristic2D = .Manhattan) {
//        self.source = source;
//        self.model = model;
//        self.h = huristic;
//    }
//    
//    
//    ///neighbors
//    public func neighbors(around vertex: Vertex) -> [(vertex: Vertex, cost: Int)]{
//        var array: [(vertex: Vertex, cost: Int)] = [];
//        //检测是否可以通过角落
//        for n in model.neighbors(around: vertex.x, y: vertex.y) {
//            if let cost = source.costOf(x: n.x, y: n.y) {
//                var c = cost * 10;
//                if n.x != vertex.x && n.y != vertex.y{
//                    c = cost * 14;
//                }
//                let v = Vertex(x: n.x, y: n.y);
//                array.append((v, c));
//            }
//        }
//        return array;
//    }
//    
//    ///successors, return jumpablexxx 忽略cost，cost ＝ 1
//    public func successors(around vertex: Vertex, from: Vertex?) -> [(vertex: Vertex, cost: Int)] {
//        var array: [(vertex: Vertex, cost: Int)] = [];
//        //检测是否可以通过角落
//        for n in model.neighbors(around: vertex.x, y: vertex.y) {
//            let v = Vertex(x: n.x, y: n.y);
//            if let vertex = jumable(vertex: v, from: vertex){
//                let g = Int(FinderHeuristic2D.Octile.huristic(dx: 0, dy: 0) * 10);
//                array.append((vertex, g));
//            }
//        }
//        return array;
//
//    }
//    
//    public func jumable(vertex: Vertex, from v: Vertex) -> Vertex? {
//        var x = vertex.x;
//        var y = vertex.y;
//        let dx = x - v.x > 0 ? 1 : -1;
//        let dy = y - v.y > 0 ? 1 : -1;
//        repeat{
//            x += dx;
//            y += dy;
//            if source.costOf(x: x, y: y) == nil {
//                x -= dx;
//                y -= dy;
//            }
//        }while true
//        let vertex = Vertex(x: x, y: y);
//        return vertex;
//    }
//}
//
///**
// 
// source: costof(vertex) -> Int?
// 
// huristic(vertex, vertex)
// 
// astar cost -> cost || rate * cost; heuristic -> heristic
// greedy heristic
// dijxx cost -> cost || rate * cost;
// bfs cost -> 1 || rate
// 
// 
// jps cost -> huristic + g; huristic? -> heuristic
// */
//
//
//public protocol FinderDataSource {
//    /// A type that can represent the vertex to associate with `element`
//    associatedtype Vertex;
//    
//    ///neighbors
//    func neighbors(around: Vertex) -> [(vertex: Vertex, cost: Int)]
//    
//    
//}



