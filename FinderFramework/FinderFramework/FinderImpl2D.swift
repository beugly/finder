//
//  FinderImpl2D.swift
//  FinderFramework
//
//  Created by xifangame on 16/9/28.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderHeuristic2D
public enum FinderHeuristic2D {
    case Manhattan, Euclidean, Octile, Chebyshev, None
}
extension FinderHeuristic2D {
    /// Return huristic cost
    public func huristic(dx: Int, dy: Int) -> CGFloat {
        let dx = CGFloat(dx);
        let dy = CGFloat(dy);
        var h: CGFloat;
        switch self{
        case .Manhattan:
            h = dx + dy;
        case .Euclidean:
            h = sqrt(dx * dx + dy * dy);
        case .Octile:
            let f:CGFloat = CGFloat(M_SQRT2) - 1;
            h = dx < dy ? f * dx + dy : f * dy + dx;
        case .Chebyshev:
            h = max(dx, dy);
        case .None:
            h = 0;
        }
        return h;
    }
}


//MARK: FinderExpandModel2D
public enum FinderExpandModel2D {
    case Straight, Diagonal
}
extension FinderExpandModel2D {
    ///Return neighbors
    public func neighbors() -> [(x: Int, y: Int)] {
        switch self {
        case .Straight:
            return [(-1, 0), (0, 1), (1, 0), (0, -1)];
        case .Diagonal:
            return [(-1, 0), (0, 1), (1, 0), (0, -1), (-1, 1), (-1, -1), (1, -1), (1, 1)];
        }
    }
}


public protocol FinderDataSource2D {
    ///return cost
    func costOf(x: Int, y: Int) -> Int?
}


public struct FinderOption2D<Source: FinderDataSource2D>{
    
    fileprivate let source: Source;
    
    fileprivate let h: FinderHeuristic2D;
    
    fileprivate let _neighbors: [(x: Int, y: Int)];
    
    public init(source: Source, useDiagonal: Bool = false, huristic: FinderHeuristic2D = .Manhattan) {
        self.source = source;
        let model: FinderExpandModel2D = useDiagonal ? .Diagonal : .Straight;
        self._neighbors = model.neighbors();
        self.h = huristic;
    }
}
extension FinderOption2D: FinderOptionProtocol {
    
    public typealias Vertex = FinderVertex2D;
    
    public func neighbors(around vertex: Vertex) -> [Vertex] {
        var array: [Vertex] = [];
        for n in _neighbors {
            var v = vertex;
            v.x = vertex.x + n.x;
            v.y = vertex.y + n.y;
            array.append(v);
        }
        return array;
    }
    
    public func exactCostOf(_ vertex: Vertex, from parent: Vertex) -> Int? {
        guard let cost = source.costOf(x: Int(vertex.x), y: Int(vertex.y)) else {
            return nil;
        }
        
        return vertex.x != parent.x && vertex.y != parent.y ? 14 * cost : 10 * cost;
    }
    
    public func isValidOf(_ vertex: Vertex) -> Int? {
        guard let cost = source.costOf(x: Int(vertex.x), y: Int(vertex.y)) else {
            return nil;
        }
        return Int(cost * 10);
    }
    
    public func heuristic(from v1: Vertex, to v2: Vertex) -> Int {
        let dx = Int(v1.x - v2.x);
        let dy = Int(v1.y - v2.y);
        return Int(h.huristic(dx: dx, dy: dy) * 10);
    }
}



