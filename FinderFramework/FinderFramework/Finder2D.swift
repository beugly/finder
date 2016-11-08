//
//  Finder2D.swift
//  FinderFramework
//
//  Created by xifangame on 16/11/8.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//FinderElement2D
public typealias FinderElement2D = FinderElement<FinderVertex2D>;

//MARK: FinderVertex2D
public struct FinderVertex2D{
    
    ///position in system coordinate
    public var x, y: Int;
    
    ///placement weight
    public let placementWeight: CGFloat;
    
    ///init
    public init(x: Int, y: Int, placementWeight: CGFloat){
        self.x = x;
        self.y = y;
        self.placementWeight = placementWeight;
    }
    
    public var hashValue: Int {
        return x << 10 + y;
    }
}
extension FinderVertex2D: FinderVertexProtocol{}
extension FinderVertex2D: Hashable {}
public func ==(lsh: FinderVertex2D, rsh: FinderVertex2D) -> Bool {
    return lsh.x == rsh.x && lsh.y == rsh.y;
}

//MARK: FinderGrid2DProtocol
public protocol FinderGrid2DProtocol {
    /// - Returns: placement at column, row
    func placementWeight(at column: Int, row: Int) -> CGFloat?
}

//MARK: FinderGrid2D
public struct FinderGrid2D {
    
    /// columns and rows
    public let columns, rows: Int;
    
    ///array
    fileprivate var array: [CGFloat?]
    
    ///init
    public init(columns: Int, rows: Int, initialValue: CGFloat? = nil) {
        self.columns = columns;
        self.rows = rows;
        array = .init(repeating: initialValue, count: rows * columns)
    }
    
    ///set placement
    public mutating func setPlacementWeight(_ weight: CGFloat?, at column: Int, row: Int) {
        guard column < columns && row < rows else {
            return;
        }
        array[row * columns + column] = weight;
    }
}
extension FinderGrid2D: FinderGrid2DProtocol {
    public func placementWeight(at column: Int, row: Int) -> CGFloat? {
        guard column < columns && row < rows else {
            return nil;
        }
        return array[row * columns + column];
    }
}

//MARK: FinderOption2D
public struct FinderOption2D<Source: FinderGrid2DProtocol>{
    
    ///source
    fileprivate let source: Source;
    
    ///expanding model
    fileprivate let model: FinderGrid2DExpandModel;
    
    ///estimated cost
    fileprivate let h: FinderHeuristic2D;
    
    ///init
    public init(source: Source, expandModel: FinderGrid2DExpandModel = .Straight, huristic: FinderHeuristic2D = .Manhattan) {
        self.source = source;
        self.model = expandModel;
        self.h = huristic;
    }
    
}
extension FinderOption2D: FinderOptionProtocol {
    
    public typealias Vertex = FinderVertex2D;
    
    ///creat neighbors
    private func createNeighbors(origin vertex: Vertex, neighborOffsets: [(Int, Int)]) -> [Vertex] {
        var array: [Vertex] = [];
        let originx = vertex.x;
        let originy = vertex.y;
        for n in neighborOffsets {
            let x = originx + n.0;
            let y = originy + n.1;
            if let placementWeight = source.placementWeight(at: x, row: y) {
                let neighbor = Vertex(x: x, y: y, placementWeight: placementWeight);
                array.append(neighbor);
            }
        }
        return array;
    }
    
    public func neighbors(around vertex: Vertex) -> [Vertex] {
        let _straightOffsets = [(-1, 0), (0, 1), (1, 0), (0, -1)];
        var array: [Vertex] = createNeighbors(origin: vertex, neighborOffsets: _straightOffsets);
        
        if model == .Diagonal {
            let _diagonalNeighbors = [(-1, 1), (-1, -1), (1, -1), (1, 1)];
            let diagonalNeighbors = createNeighbors(origin: vertex, neighborOffsets: _diagonalNeighbors);
            array.append(contentsOf: diagonalNeighbors);
        }
        else if model == .DiagonalIfNoObstacles {
            
        }
        else if model == .DiagonalIfAtMostOneObstacles {
            
        }
        
        
        let originx = vertex.x;
        let originy = vertex.y;
        var neighborsDic: [Finder2DDirection: Vertex] = [:];
        for (k, v) in Finder2DDirection.straightOffsets() {
            let x = originx + v.0;
            let y = originy + v.1;
            if let placementWeight = source.placementWeight(at: x, row: y) {
                let neighbor = Vertex(x: x, y: y, placementWeight: placementWeight);
                neighborsDic[k] = neighbor;
            }
        }

        
        
        
        
        return array;
    }
    
    public func estimatedCost(from current: Vertex, to target: Vertex) -> CGFloat {
        return h.huristic(from: current.x, y1: current.y, to: target.x, y2: target.y);
    }
    
    public func cost(of current: Vertex, from parent: Vertex) -> CGFloat {
        let weight = current.placementWeight;
        return current.x != parent.x && current.y != parent.y ? 1.4 * weight : weight;
    }
}

//MARK: FinderGrid2DExpandModel
public enum FinderGrid2DExpandModel {
    case Straight,                  //stright
    Diagonal,                       // always diagonal
    DiagonalIfNoObstacles,          //diagonal if no obstacles
    DiagonalIfAtMostOneObstacles    //diagonal if at most one obstacles
    
//    case .Straight:
//    return [(-1, 0), (0, 1), (1, 0), (0, -1)];
//    case .Diagonal:
//    return [(-1, 0), (0, 1), (1, 0), (0, -1), (-1, 1), (-1, -1), (1, -1), (1, 1)];
}

//MARK: FinderHeuristic2D
public enum FinderHeuristic2D {
    case Manhattan, Euclidean, Octile, Chebyshev
}
extension FinderHeuristic2D {
    
    /// Return huristic cost
    public func huristic(from x1: Int, y1: Int, to x2: Int, y2: Int) -> CGFloat {
        let dx = CGFloat(abs(x1 - x2));
        let dy = CGFloat(abs(y1 - y2));
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
        }
        return h;
    }
}

//MARK: Finder2DDirection
fileprivate enum Finder2DDirection {
    case Left, Top, Right, Buttom, LeftTop, RightTop, LeftButtom, RightButtom
}
extension Finder2DDirection {
    static func straightOffsets() -> [Finder2DDirection: (Int, Int)] {
        return [.Left: (-1, 0), .Top: (0, 1), .Right: (1, 0), .Buttom: (0, -1)];
    }
    static func diagonalOffsets() -> [Finder2DDirection: (Int, Int)] {
        return [.LeftTop: (-1, 1), .RightTop: (1, 1), .LeftButtom: (-1, -1), .RightButtom: (1, -1)];
    }
}
