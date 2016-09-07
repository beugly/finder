//
//  FinderProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/3/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

///FinderAbstract
public protocol FinderAbstract{
    
    ///Vertex Type
    associatedtype Vertex: Hashable;
    
    ///Goal Type
    associatedtype Goal = Vertex;
    
    ///origin
    var origin: Vertex {get}
    
    ///goal
    var goal: Goal{get set}
    
    ///Finder is complete
    var isComplete: Bool {get set}
    
    ///Return vertex is one of goals
    mutating func isGoal(vertex: Vertex) -> Bool
    
    ///Return movement cost from v1 to v2
    func movementCost(from v1: Vertex, to v2: Vertex) -> Int?
    
    ///Return h value of vertex
    func heuristic(of vertex: Vertex) -> Int
    
    ///Return successors of vertex from v
    func successorsOf(vertex: Vertex, from v: Vertex) -> [Vertex]
    
    
    
    ///Storage Type
    associatedtype Storage: FStorage;
}
extension FinderAbstract {
    mutating public func isGoal(vertex: Vertex) -> Bool{
        return false;
    }
}
extension FinderAbstract where Goal == Vertex{
    ///Return vertex is one of goals
    mutating public func isGoal(vertex: Vertex) -> Bool{
        guard vertex == goal else {
            return false;
        }
        isComplete = true;
        return true;
    }
}
extension FinderAbstract where Goal == [Vertex]{
    ///Return vertex is one of goals
    mutating public func isGoal(vertex: Vertex) -> Bool{
        guard let index = goal.indexOf(vertex) else {
            return false;
        }
        goal.removeAtIndex(index);
        if goal.isEmpty {
            isComplete = true;
        }
        return true;
    }
}
extension FinderAbstract where Storage.Vertex == Self.Vertex {
    
    ///execute
    mutating public func execute(@noescape findOne: [Vertex] -> Void) -> Storage{
        var storage = Storage();
        let h = heuristic(of: origin);
        let originEle = FElement<Vertex>(vertex: origin, parent: nil, g: 0, h: h);
        storage.insert(originEle);
        
        repeat{
            guard let element = storage.removeBest() else {
                break;
            }
            
            let vertex = element.vertex;
            if isGoal(vertex) {
                let result = storage.backtrace(vertex);
                findOne(result);
            }
            
            if isComplete{
                break;
            }
            
            let parentVertex = element.parent ?? vertex;
            successorsOf(vertex, from: parentVertex).forEach {
                let successor = $0;
                
                guard let cost = movementCost(from: vertex, to: successor) else {
                    return;
                }
                
                let g = cost + element.g;
                if let old = storage.elementOf(successor) where !old.isClosed && old.g > g{
                    var newElement = old;
                    newElement.g = g;
                    newElement.parent = vertex;
                    storage.update(newElement);
                    return;
                }
                
                let h = heuristic(of: successor);
                let ele = FElement<Vertex>(vertex: successor, parent: vertex, g: g, h: h);
                storage.insert(ele);
            }
        }while true
        return storage;
    }
}






public struct FOne2One<Vertex: Hashable> {
    
    public let origin: Vertex;
    
    public var goal: Vertex;
    
    public var isComplete: Bool = false;
    
    public typealias Storage = FHeap<Vertex>;
}
extension FOne2One: FinderAbstract{
    ///Return movement cost from v1 to v2
    public func movementCost(from v1: Vertex, to v2: Vertex) -> Int?{
        return 1;
    }
    
    ///Return h value of vertex
    public func heuristic(of vertex: Vertex) -> Int{
        return 0;
    }
    
    ///Return successors of vertex from v
    public func successorsOf(vertex: Vertex, from v: Vertex) -> [Vertex]{
        return [];
    }
}




public struct FOne2Many<Vertex: Hashable, Goal> {
    
    public let origin: Vertex;
    
    public var goal: Goal;
    
    public init(origin: Vertex, goal: Goal){
        self.origin = origin;
        self.goal = goal;
    }
    
    public var isComplete: Bool = false;
    
    public typealias Storage = FHeap<Vertex>;
}
extension FOne2Many: FinderAbstract{
    ///Return movement cost from v1 to v2
    public func movementCost(from v1: Vertex, to v2: Vertex) -> Int?{
        return 1;
    }
    
    ///Return h value of vertex
    public func heuristic(of vertex: Vertex) -> Int{
        return 0;
    }
    
    ///Return successors of vertex from v
    public func successorsOf(vertex: Vertex, from v: Vertex) -> [Vertex]{
        return [];
    }
}
