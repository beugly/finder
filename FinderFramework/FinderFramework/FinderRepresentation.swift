//
//  FinderRepresentation.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/11/5.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

//MARK: FinderProtocol
public protocol FinderProtocol{
    
    /// The FinderSequence type
    associatedtype S: FinderSequence;
    
    /**
     * - Returns new sequence
     */
    func makeSequence() -> S
    
    /**
     * Expanding successor elements around 'element'
     */
    func expandSuccessors(around element: S.Element, into sequence: inout S, towards target: S.Vertex)
    
    /**
     * Attempts to find the optimal path between the two vertex indicated.
     * If such a path exists, it is returned in start to target order.
     * If it doesn't exist, the array returned will be empty.
     */
    func find(target: S.Vertex, from start: S.Vertex, completion: ((S) -> Void)?) -> [S.Vertex]
}
extension FinderProtocol where S.Vertex: Hashable, S.Element == FinderElement<S.Vertex> {
    public func find(target: S.Vertex, from start: S.Vertex, completion: ((S) -> Void)?) -> [S.Vertex] {
        var sequence = makeSequence();
        let origin = S.Element(vertex: start, parent: nil, g: 0, h: 0);
        sequence.push(origin);
        
        defer {
            if let completion = completion{
                completion(sequence)
            }
        }
        
        repeat {
            guard let element = sequence.pop() else {
                break;
            }
            
            if target == element.vertex {
                return sequence.backtrace(of: target).reversed();
            }
            
            expandSuccessors(around: element, into: &sequence, towards: target);
        }while true
        return [];
    }
}

//MARK: FinderManyToOne
public protocol FinderManyToOne: FinderProtocol {
    /**
     * Attempts to find the optimal paths from starts to target.
     * If such a path exists, it is returned path array in start to target order.
     * If it doesn't exist, the array returned will be empty.
     */
    func find(target: S.Vertex, from starts: [S.Vertex], completion: ((S) -> Void)?) -> [[S.Vertex]]
}
extension FinderManyToOne where S.Vertex: Hashable, S.Element == FinderElement<S.Vertex> {
    public func find(target: S.Vertex, from starts: [S.Vertex], completion: ((S) -> Void)?) -> [[S.Vertex]] {
        var sequence = makeSequence();
        let origin = S.Element(vertex: target, parent: nil, g: 0, h: 0);
        sequence.push(origin);
        
        defer {
            if let completion = completion{
                completion(sequence)
            }
        }
        
        var result: [[S.Vertex]] = [];
        var starts = starts;
        repeat {
            guard let element = sequence.pop() else {
                break;
            }
            
            let vertex = element.vertex;
            if let i = starts.index(of: vertex) {
                let r = sequence.backtrace(of: vertex);
                result.append(r);
                starts.remove(at: i);
                if starts.isEmpty {
                    break;
                }
            }
            
            expandSuccessors(around: element, into: &sequence, towards: target);
        }while true
        return result;
    }
}


//MARK: FinderAstar
public struct FinderAstar_<Option: FinderOptionProtocol> {
    public var option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderAstar_: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func makeSequence() -> S {
        return S();
    }
    
    public func expandSuccessors(around element: S.Element, into sequence: inout S, towards target: S.Vertex) {
        let vertex = element.vertex;
        for neighbor in option.neighbors(around: vertex) {
            let cost = option.cost(of: neighbor, from: vertex);
            if var old = sequence.element(of: neighbor) {
                if old.isClosed{
                    continue;
                }
                
                let g = element.g + cost;
                if g >= old.g {
                    continue;
                }
                old.update(vertex, g: g);
                sequence.update(old);
            }
            else {
                let h = option.estimatedCost(from: neighbor, to: target);
                let e = S.Element(vertex: neighbor, parent: vertex, g: element.g + cost, h: h);
                sequence.push(e);
            }
        }
    }
}

//MARK: FinderGreedyBest
public struct FinderGreedyBest_<Option: FinderOptionProtocol> {
    public var option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderGreedyBest_: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func makeSequence() -> S {
        return S();
    }
    
    public func expandSuccessors(around element: S.Element, into sequence: inout S, towards target: S.Vertex) {
        let vertex = element.vertex;
        for neighbor in option.neighbors(around: vertex) {
            if sequence.element(of: neighbor) == nil {
                let h = option.estimatedCost(from: neighbor, to: target);
                let e = S.Element(vertex: neighbor, parent: vertex, g: 0, h: h);
                sequence.push(e);
            }
        }
    }
}


//MARK: FinderDijkstra
public struct FinderDijkstra_<Option: FinderOptionProtocol> {
    public var option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderDijkstra_: FinderProtocol {
    public typealias S = FinderHeap<Option.Vertex>;
    
    public func makeSequence() -> S {
        return S();
    }
    
    public func expandSuccessors(around element: S.Element, into sequence: inout S, towards target: S.Vertex) {
        let vertex = element.vertex;
        for neighbor in option.neighbors(around: vertex) {
            let cost = option.cost(of: neighbor, from: vertex);
            if var old = sequence.element(of: neighbor) {
                if old.isClosed{
                    continue;
                }
                
                let g = element.g + cost;
                if g >= old.g {
                    continue;
                }
                old.update(vertex, g: g);
                sequence.update(old);
            }
            else {
                let e = S.Element(vertex: neighbor, parent: vertex, g: element.g + cost, h: 0);
                sequence.push(e);
            }
        }
    }
}


//MARK: FinderBFS
public struct FinderBFS_<Option: FinderOptionProtocol> {
    public var option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderBFS_: FinderProtocol, FinderManyToOne {
    public typealias S = FinderArray<Option.Vertex>;
    
    public func makeSequence() -> S {
        return S();
    }
    
    public func expandSuccessors(around element: S.Element, into sequence: inout S, towards target: S.Vertex) {
        let vertex = element.vertex;
        for neighbor in option.neighbors(around: vertex) {
            if sequence.element(of: neighbor) == nil {
                let e = S.Element(vertex: neighbor, parent: vertex, g: 0, h: 0);
                sequence.push(e);
            }
        }
    }
}




