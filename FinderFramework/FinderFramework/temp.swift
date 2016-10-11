//
//  temp.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 2016/10/12.
//  Copyright © 2016年 xifangame. All rights reserved.
//

import Foundation


//MARK: FinderSequence
/// A finder sequence
public protocol FinderSequence{
    /// A type that can represent the vertex to associate with `element`
    associatedtype Vertex: Hashable;
    
    /// A type that can represent the element to associate with `vertex`
    associatedtype Element = FinderElement<Vertex>;
    
    /// Inserts the given element into the sequence unconditionally.
    /// - Parameter newElement: An element to insert into the sequence
    mutating func insert(_ newElement: Element)
    
    /// Pop the best element
    /// - Returns: the best element if the sequence is not empty; othewise, 'nil'
    mutating func popBest() -> Element?
    
    /// Inserts the given element into the sequence unconditionally.
    /// - Parameter newElement: An element to insert into the sequence
    /// - Returns: element equal to `newElement` if the sequence already contained
    ///   such a element; otherwise, `nil`.
    mutating func update(_ newElement: Element) -> Element?
    
    /// Return element of vertex.
    /// - Parameters:
    ///   - vertex: The vertex to associate with `element`
    /// - Returns: the existing associated element of 'vertex' 
    ///   if 'vertex' already in the sequence; otherwise, 'nil'.
    func element(of vertex: Vertex) -> Element?
}
extension FinderSequence {
    ///Start-up
    /// - Parameter expanding: expanding function for expanding successors elements around first argument
    ///   and insert or update new element to second argument
    mutating func startup(expanding: (Element, inout Self) -> Bool) {
        repeat {
            guard let element = popBest() else {
                break;
            }
            
            let isComplete = expanding(element, &self);
            if isComplete {
                break;
            }
        }while true
    }
}
