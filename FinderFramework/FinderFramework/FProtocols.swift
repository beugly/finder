//
//  FProtocols.swift
//  FinderFramework
//
//  Created by xifangame on 16/9/22.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation



public protocol FinderProtocol00000 {
    
    ///Option type
    associatedtype Option: FinderOptionProtocol;
    
    ///find
    func find(from v1: Option.Vertex, to v2: Option.Vertex, option: Option) -> [Option.Vertex]?
}
extension FinderProtocol00000 {
    ///Heap type
    public typealias H = FinderHeap<Option.Vertex>;
    
    ///find
    public func find(from v1: Option.Vertex, to v2: Option.Vertex, option: Option) -> [Option.Vertex]? {
        var heap = H();
        let origin = H.Element(vertex: v1, parent: nil);
        heap.insert(element: origin);
        var result: [Option.Vertex]? = nil;
        repeat{
            ///get best element
            guard let element = heap.removeBest() else {
                break;
            }
            let vertex = element.vertex;
            
            ///check vertex
            if vertex == v2 {
                result = heap.backtrace(vertex: vertex).reversed();
                break;
            }
            
            ///expand successors
            let successors = option.successors(of: vertex, from: element.parent);
            for successor in successors {
                if let visited = heap.visitedOf(vertex: successor) {
                    if visited.isClosed {continue;}
//                    if let ele = updateElement(visited: visited.element, parent: element)
                    //update
                    //old parent option
                }
                else{
//                    let ele = makeElement(from: successor, to: v2, parent: element);
//                    heap.insert(element: ele);
                }
            }
        }while true;
        return result;
    }
}



public protocol FinderProtocol000002 {
    
    ///Option type
    associatedtype Option: FinderOptionProtocol;
    
    ///find
    func find(from vertexs: [Option.Vertex], to vertex: Option.Vertex, option: Option) -> [[Option.Vertex]]
}
extension FinderProtocol000002 {
    ///Heap type
    public typealias H = FinderHeap<Option.Vertex>;
    
    ///find
    public func find(from vertexs: [Option.Vertex], to vertex: Option.Vertex, option: Option) -> [[Option.Vertex]] {
        var heap = H();
        let origin = H.Element(vertex: vertex, parent: nil);
        heap.insert(element: origin);
        var result: [[Option.Vertex]] = [];
        var goals = vertexs;
        repeat{
            ///get best element
            guard let element = heap.removeBest() else {
                break;
            }
            let vertex = element.vertex;
            
            ///check vertex
            if isGoal(vertex: vertex, goals: &goals) {
                let r = heap.backtrace(vertex: vertex);
                result.append(r);
            }
            if goals.isEmpty {
                break;
            }
            
            ///expand successors
            let successors = option.successors(of: vertex, from: element.parent);
            for successor in successors {
                if let visited = heap.visitedOf(vertex: successor) {
                    if visited.isClosed {continue;}
//                    if let ele = updateElement(visited: visited.element, parent: element)
//                    update
//                    old parent option
                }
                else{
//                    let ele = makeElement(from: successor, to: v2, parent: element);
//                    heap.insert(element: ele);
                }
            }
        }while true;
        return result;
    }
    
    ///find goal
    private func isGoal(vertex: Option.Vertex, goals: inout [Option.Vertex]) -> Bool{
        if goals.count == 1 {
            guard vertex == goals[0] else {
                return false;
            }
            goals.remove(at: 0);
            return true;
        }
        
        guard let i = goals.index(of: vertex) else {
            return false;
        }
        goals.remove(at: i);
        return true;
    }
}







