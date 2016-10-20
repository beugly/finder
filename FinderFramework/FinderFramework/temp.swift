//
//  temp.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/10/12.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation

public struct FinderBreadthFirst<T: FinderOptionProtocol> {
    let option: Option;
    public init(option: Option) {
        self.option = option;
    }
}
extension FinderBreadthFirst {
    public typealias Option = T;
    public typealias Vertex = Option.Vertex;
    fileprivate typealias Element = FinderElement<Vertex>;
}
extension FinderBreadthFirst {
    private typealias S = FinderArray<Vertex>;
    private static func makeSequence(origin: Vertex) -> S {
        var array = S();
        let element = Element(vertex: origin, parent: nil, g: 0, h: 0);
        array.push(element);
        return array;
    }
    private static func expanding(around vertex: Vertex, array: inout S, option: Option){
        for neighbor in option.neighbors(around: vertex) {
            if array.element(of: neighbor) != nil {
                continue;
            }
            let ele = Element(vertex: neighbor, parent: vertex, g: 0, h: 0);
            array.push(ele);
        }
    }
    
    public func find(from start: Vertex, to goal: Vertex) -> [Vertex]?{
        var array = FinderBreadthFirst.makeSequence(origin: start);
        repeat {
            guard let element = array.pop() else {
                break;
            }
            let vertex = element.vertex;
            if vertex == goal{
                return array.backtrace(of: vertex).reversed();
            }
            
            FinderBreadthFirst.expanding(around: vertex, array: &array, option: option);
        }while true;
        return nil;
    }
    
    public func find(from starts: [Vertex], to goal: Vertex) -> [[Vertex]]{
        var array = FinderBreadthFirst.makeSequence(origin: goal);
        var vertexs = starts;
        var result: [[Vertex]] = [];
        
        repeat {
            guard let element = array.pop() else {
                break;
            }
            let vertex = element.vertex;
            
            if let i = vertexs.index(of: vertex) {
                let r = array.backtrace(of: vertex);
                result.append(r);
                vertexs.remove(at: i);
                if vertexs.isEmpty {
                    break;
                }
            }
            FinderBreadthFirst.expanding(around: vertex, array: &array, option: option);
        }while true;
        return result;
    }
}
