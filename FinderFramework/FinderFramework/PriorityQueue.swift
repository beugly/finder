//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation


//MARK: PriorityQueue
/// minimum - isOrderedBefore: $0 < $1
/// maximum - isOrderedBefore: $0 > $1
/// forkCount - fork count, heap: forkCount = 2
public struct PriorityQueue<Element> {
    /// A type that can represent the data source
    public typealias Source = [Element];
    
    /// source
    public fileprivate(set) var source: Source = [];
    
    /// is order before
    let iob: (Element, Element) -> Bool;
    
    /// fork count
    let forkCount: Int;
    
    /// Init
    public init(isOrderedBefore: @escaping (Element, Element) -> Bool, forkCount: Int){
        self.iob = isOrderedBefore;
        self.forkCount = forkCount;
    }
    
    /// init heap
    public init(heap isOrderedBefore: @escaping (Element, Element) -> Bool) {
        self.init(isOrderedBefore: isOrderedBefore, forkCount: 2);
    }
}
//MARK: PriorityQueue.heap where T: Comparable
extension PriorityQueue where Element: Comparable {
    ///Return minimum
    public init(minimum forkCount: Int = 2){
        self.init(isOrderedBefore: {
            return $0 < $1;
            }, forkCount: forkCount);
    }
    
    ///Return maximum
    public init(maximum forkCount: Int = 2){
        self.init(isOrderedBefore: {
            return $0 > $1;
            }, forkCount: forkCount);
    }
}
//MARK: extension PriorityQueue
extension PriorityQueue{
    
    /// Optimal element preview
    public var preview: Element? {
        return source.first;
    }
    
    /// Inserts the given element into the sequence unconditionally.
    /// - Parameter newElement: An element to insert into the sequence
    mutating public func insert(_ newElement: Element) {
        source.append(newElement);
        shift(up: source.count - 1);
    }
    
    /// Pop the optimal element
    /// - Returns: the best element if the sequence is not empty; othewise, 'nil'
    mutating public func popBest() -> Element? {
        guard !source.isEmpty else {return nil;}
        guard source.count > 1 else{return source.removeLast();}
        let first = source[0];
        source[0] = source.removeLast();
        shift(down: 0);
        return first;
    }
    
    /// Inserts the given element into the sequence at index.
    /// - Parameters:
    ///     - element: An element to insert into the sequence
    ///     - index: position index
    /// - Returns: element equal to `element` if the sequence already contained
    ///   such a element; otherwise, `nil`.
    @discardableResult
    mutating public func updateElement(_ element: Element, atIndex index: Int) -> Element? {
        guard index < source.count else {
            return nil;
        }
        let old = source[index];
        source[index] = element;
        shift(auto: index);
        return old;
    }
    
    /// Build priority queue
    /// - Parameters: 
    ///     - newSource: data source
    mutating public func build(_ newSource: Source) {
        self.source = newSource;
        guard !source.isEmpty else {
            return;
        }
        
        let eIndex = source.count - 1;
        var index = parentIndexOf(eIndex);
        
        while index >= 0{
            shift(down: index);
            index -= 1;
        }
    }
}
//MARK: extension PriorityQueue: shifting function
extension PriorityQueue {
    ///Shift up at index
    mutating func shift(up index: Int){
        let shiftElement = source[index];
        var shiftIndex = index;
        
        while shiftIndex > 0{
            let pIndex = parentIndexOf(shiftIndex);
            guard iob(shiftElement, source[pIndex]) else {
                break;
            }
            swap(&source[shiftIndex], &source[pIndex])
            shiftIndex = pIndex;
        }
    }
    
    ///shift down at index
    mutating func shift(down index: Int) {
        let eIndex = source.count;
        var pIndex = index;
        repeat{
            var shiftIndex = pIndex;
            var cIndex = childIndexOf(shiftIndex);
            let temp = cIndex + forkCount;
            let ceIndex = temp > eIndex ? eIndex : temp;
            
            while ceIndex > cIndex{
                if iob(source[cIndex], source[shiftIndex]) {
                    shiftIndex = cIndex;
                }
                cIndex += 1;
            }
            
            guard shiftIndex != pIndex else {
                break;
            }
            swap(&source[pIndex], &source[shiftIndex])
            pIndex = shiftIndex;
        }while true;
    }
    
    ///Auto shift element at index
    mutating func shift(auto index: Int) {
        guard index >= 0 else {
            return;
        }
        
        let pIndex = parentIndexOf(index);
        iob(source[index], source[pIndex]) ? shift(up: index) : shift(down: index);
    }
    
    /// Return parent index
    /// - Parameter index: child index
    /// - Returns: parent index of child index
    func parentIndexOf(_ index: Int) -> Int{
        return (index - 1) / forkCount;
    }
    
    /// Return minimum child index
    /// - Parameter index: parent index
    /// - Returns: minimum child index of parent index
    func childIndexOf(_ index: Int) -> Int {
        return index * forkCount + 1;
    }
}
//MARK: extension PriorityQueue: CollectionType
extension PriorityQueue: Collection {
    public var count: Int{return source.count;}
    public var startIndex: Int{return source.startIndex;}
    public var endIndex: Int{return source.endIndex;}
    public subscript(index: Int) -> Element {return source[index];}
    public func index(after i: Int) -> Int {return i + 1;}
}
