//
//  FinderImpl2D.swift
//  FinderFramework
//
//  Created by xifangame on 16/9/28.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderVertex2D
public protocol FinderVertex2D {
    var x: Int {get}
    var y: Int {get}
    init(x: Int, y: Int)
}

//MARK: FinderCost2D
public enum FinderCostModel2D {
    case Manhattan, Euclidean, Octile, Chebyshev, None
}
extension FinderCostModel2D {
    ///return cost from v1 to v2
    public func cost<T: FinderVertex2D>(from v1: T, to v2: T) -> Int {
        let dx = CGFloat(abs(v1.x - v2.x));
        let dy = CGFloat(abs(v1.y - v2.y));
        let h: CGFloat!;
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
        return Int(h * 10);
    }
}

public enum FinderSearchModel2D {
    case Straight, Diagonal
}
extension FinderSearchModel2D {
    func neighborsOfOrigin() -> [(x: Int, y: Int)] {
        switch self {
        case .Straight:
            return [(-1, 0), (0, 1), (1, 0), (0, -1)];
        case .Diagonal:
            return [(-1, 0), (0, 1), (1, 0), (0, -1), (-1, 1), (-1, -1), (1, -1), (1, 1)];
        }
    }
}



//MARK: FinderOption2DProtocol
public protocol FinderOption2DProtocol: FinderOptionProtocol {
    ///vertex type
    associatedtype Vertex: FinderVertex2D, Hashable;
    
    ///cost model
    var costModel: FinderCostModel2D {get}
    
    ///search model
    var searchModel: FinderSearchModel2D {get}
    
    ///use jump
    var jump: Bool{get}
    
    func validateOf(x: Int, y: Int) -> Bool
}
extension FinderOption2DProtocol {
    func neighbors(around vertex: Vertex) -> [Vertex] {
        var ns: [Vertex] = [];
        let offsets = searchModel.neighborsOfOrigin();
        for offset in offsets {
            let x = vertex.x + offset.x;
            let y = vertex.y + offset.y;
            guard validateOf(x: x, y: y) else {
                continue;
            }
            
            let v = Vertex(x: x, y: y);
            ns.append(v);
        }
        return ns;
    }
    
    public func successors(of vertex: Vertex, from parent: Vertex?) -> [Vertex] {
        return neighbors(around: vertex);
    }
}
