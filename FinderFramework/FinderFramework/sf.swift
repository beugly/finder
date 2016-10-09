//
//  sf.swift
//  FinderFramework
//
//  Created by xifangame on 16/10/9.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


public struct F121<Option: FinderOptionProtocol> {
    ///properties
    public let start, goal: Option.Vertex, option: Option;
    
    ///heap
    public private(set) var heap = FinderHeap<Option.Vertex>();
    
    ///init
    public init(start: Option.Vertex, goal: Option.Vertex, option: Option) {
        self.start = start;
        self.goal = goal;
        self.option = option;
    }
    
    ///find
    mutating func find() -> [Option.Vertex]?{
        var result: [Option.Vertex]?;
        let origin = FinderElement(vertex: start, parent: nil, g: 0, h: 0);
        heap.insert(element: origin);
        repeat {
            //get best element
            guard let element = heap.next() else {
                break;
            }
            
            //check state
            let vertex = element.vertex;
            if goal == vertex {
                result = heap.backtrace(of: vertex).reversed();
                break;
            }
            
            //expand successors
//            expandSuccessors(around: element, into: &heap);
        }while true
        return result;
    }
}
