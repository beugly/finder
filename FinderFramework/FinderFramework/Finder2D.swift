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

//FinderGrid2DOption
public typealias FinderGrid2DOption = FinderOption2D<FinderGrid2D>;

//MARK: FinderVertex2D
public struct FinderVertex2D{
    
    ///position in system coordinate
    public var x, y: Int;
    
    ///placement weight
    public let placementWeight: CGFloat;
    
    ///init
    public init(x: Int, y: Int, placementWeight: CGFloat = 1){
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
    
    var columns: Int{
        return source.columns;
    }
    
    var rows: Int{
        return source.rows;
    }
    
    ///array
    fileprivate var source: FinderArray2D<CGFloat?>;
    
    ///init
    public init(columns: Int, rows: Int, initialValue: CGFloat? = nil) {
        source = .init(columns: columns, rows: rows, initialValue: initialValue);
    }
    
    ///set placement
    public mutating func setPlacementWeight(_ weight: CGFloat?, at column: Int, row: Int) {
        guard column > -1 && column < source.columns && row > -1 && row < source.rows else {
            return;
        }
        source[column, row] = weight;
    }
}
extension FinderGrid2D: FinderGrid2DProtocol {
    public func placementWeight(at column: Int, row: Int) -> CGFloat? {
        guard column > -1 && column < source.columns && row > -1 && row < source.rows else {
            return nil;
        }
        return source[column, row];
    }
}

//MARK: FinderOption2D
public struct FinderOption2D<Source: FinderGrid2DProtocol>{
    
    ///source
    fileprivate let source: Source;
    
    ///expanding model
    fileprivate let expandModel: FinderGrid2DExpandModel;
    
    ///estimated cost
    fileprivate let heuristic: FinderHeuristic2D;
    
    ///init
    public init(source: Source, expandModel: FinderGrid2DExpandModel = .Straight, huristic: FinderHeuristic2D = .Manhattan) {
        self.source = source;
        self.expandModel = expandModel;
        self.heuristic = huristic;
    }
}
extension FinderOption2D: FinderOptionProtocol {
    public typealias Vertex = FinderVertex2D;
    
    // - Returns: neighbor vertexs around origin x, y
    private func createNeighborsAround(_ originx: Int, _ originy: Int, originNeighbors: [(Int, Int)]) -> [Vertex] {
        var array: [Vertex] = [];
        for o in originNeighbors {
            let x = originx + o.0;
            let y = originy + o.1;
            if let placementWeight = source.placementWeight(at: x, row: y) {
                let neighbor = Vertex(x: x, y: y, placementWeight: placementWeight);
                array.append(neighbor);
            }
        }
        return array;
    }
    
    public func neighbors(around vertex: Vertex) -> [Vertex] {
        let originx = vertex.x;
        let originy = vertex.y;
        var atMostObstacles = 2;
        switch expandModel {
        case .Straight:
            return createNeighborsAround(originx, originy, originNeighbors: FinderGrid2DExpandModel.straightNeighbors);
        case .Diagonal:
            return createNeighborsAround(originx, originy, originNeighbors: FinderGrid2DExpandModel.allNeighbors);
        case .DiagonalIfAtMostOneObstacles:
            atMostObstacles = 1;
        case .DiagonalIfNoObstacles:
            atMostObstacles = 0;
        }
        
        var _neighbors: [Vertex] = [];
        var obstacleCounts: [Int] = [0, 0, 0, 0];
        var i = 0;
        for o in FinderGrid2DExpandModel.straightNeighbors {
            let x = originx + o.0;
            let y = originy + o.1;
            if let placementWeight = source.placementWeight(at: x, row: y) {
                let neighbor = Vertex(x: x, y: y, placementWeight: placementWeight);
                _neighbors.append(neighbor);
            }
            else {
                obstacleCounts[i] += 1;
                var temp = i - 1;
                if temp < 0 {
                    temp = 3;
                }
                obstacleCounts[temp] += 1;
            }
            i += 1;
        }
        
        var j = 0;
        for o in FinderGrid2DExpandModel.diagonalNeighbors {
            let x = originx + o.0;
            let y = originy + o.1;
            if let placementWeight = source.placementWeight(at: x, row: y), obstacleCounts[j] <= atMostObstacles {
                let neighbor = Vertex(x: x, y: y, placementWeight: placementWeight);
                _neighbors.append(neighbor);
            }
            j += 1;
        }
        return _neighbors;
    }
    
    public func estimatedCost(from current: Vertex, to target: Vertex) -> CGFloat {
        return heuristic.huristic(from: current.x, y1: current.y, to: target.x, y2: target.y);
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
    
    fileprivate static let straightNeighbors = [(-1, 0), (0, 1), (1, 0), (0, -1)];
    fileprivate static let diagonalNeighbors = [(-1, 1), (1, 1), (1, -1), (-1, -1)];
    fileprivate static let allNeighbors = [(-1, 0), (0, 1), (1, 0), (0, -1), (-1, 1), (1, 1), (1, -1), (-1, -1)];
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

//MARK: FinderArray2D
public struct FinderArray2D<T> {
    
    /// columns and rows
    public let columns, rows: Int;
    
    ///array
    fileprivate var array: [T]
    
    ///init
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns;
        self.rows = rows;
        array = .init(repeating: initialValue, count: rows * columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        set{
            array[row * columns + column] = newValue;
        }
        get{
            return array[row * columns + column];
        }
    }
}
