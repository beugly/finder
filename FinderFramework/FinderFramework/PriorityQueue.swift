//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation

//MARK: HeapBuilder
public struct HeapBuilder<T> {
    
    ///max heap (>) OR min heap (<)
    public let isOrderedBefore: (T, T) -> Bool;
    
    ///Init
    public init(isOrderedBefore: (T, T) -> Bool) {
        self.isOrderedBefore = isOrderedBefore;
    }
}
extension HeapBuilder {
    ///Shift up at index
    public func shiftUp(atIndex: Int, inout source: [T]) {
        let shiftElement = source[atIndex];
        var shiftIndex = atIndex;
        repeat{
            let parentIndex = parentIndexOf(shiftIndex);
            guard parentIndex >= 0
                && isOrderedBefore(shiftElement, source[parentIndex]) else {break;}
            swap(&source[shiftIndex], &source[parentIndex])
            shiftIndex = parentIndex;
        }while true
    }
    
    ///shift down at position
    public func shiftDown(atIndex: Int, inout source: [T]) {
        var parentIndex = atIndex;
        let c = source.count;
        repeat{
            var childIndex = childIndexOf(parentIndex);
            guard childIndex < c else {break;}
            
            var shiftIndex = parentIndex;
            if isOrderedBefore(source[childIndex], source[shiftIndex]) {
                shiftIndex = childIndex;
            }
            
            childIndex += 1;
            if childIndex < c && isOrderedBefore(source[childIndex], source[shiftIndex]) {
                shiftIndex = childIndex;
            }
            
            guard shiftIndex != parentIndex else{break;}
            swap(&source[parentIndex], &source[shiftIndex])
            parentIndex = shiftIndex;
        }while true;
    }
    
    ///Auto shift element at index
    public func autoShift(atIndex: Int, inout source: [T]) {
        let parentIndex = parentIndexOf(atIndex);
        guard parentIndex >= 0 else {
            self.shiftDown(atIndex, source: &source);
            return;
        }
        self.isOrderedBefore(source[atIndex], source[parentIndex]) ?
            shiftUp(atIndex, source: &source) :
            shiftDown(atIndex, source: &source);
    }
    
    ///Return heap array
    public func building(source: [T]) -> [T] {
        var source = source;
        guard source.count > 0 else{return source;}
        var index = parentIndexOf(source.count - 1);
        while index > -1{
            shiftDown(index, source: &source);
            index -= 1;
        }
        return source;
    }
}
extension HeapBuilder {
    ///Return parent index of child index
    func parentIndexOf(index: Int) -> Int {
        return (index - 1) >> 1;
    }
    
    ///Return min child index of parent index
    func childIndexOf(index: Int) -> Int {
        return index << 1 + 1;
    }
}



///MARK: PriorityQueue
public struct PriorityQueue<T> {
    ///source
    public private(set) var source: [T];
    
    ///heap builder
    private let builder: HeapBuilder<T>;
    
    ///Init
    public init(source: [T], isOrderedBefore: (T, T) -> Bool) {
        self.builder = HeapBuilder<T>(isOrderedBefore: isOrderedBefore);
        self.source = self.builder.building(source);
    }
    
    ///Init
    public init(isOrderedBefore: (T, T) -> Bool) {
        self.init(source: [], isOrderedBefore: isOrderedBefore);
    }
}

//MARK: extension PriorityQueue public
extension PriorityQueue{
    
    ///Preview min OR max element
    public var preview: T? {
        return source.first;
    }
    
    ///Insert element
    mutating public func insert(element: T) {
        source.append(element);
        builder.shiftUp(source.count - 1, source: &source);
    }
    
    ///Remove best element
    mutating public func popBest() -> T? {
        guard !source.isEmpty else {return nil;}
        guard source.count > 1 else{return source.removeLast();}
        let first = source[0];
        source[0] = source.removeLast();
        builder.shiftDown(0, source: &source);
        return first;
    }
    
    ///Replace element at index
    mutating public func replace(atIndex: Int, newValue: T) {
        source[atIndex] = newValue;
        builder.autoShift(atIndex, source: &source);
    }
    
    ///Rebuild priority queue
    mutating public func rebuild() {
        self.source = builder.building(source);
    }
}

//MARK: extension PriorityQueue where T: Comparable
extension PriorityQueue where T: Comparable {
    ///minimum heap
    public init(minimum source: [T]){
        self.init(source: source){return $0 < $1;}
    }
    
    ///maximum heap
    public init(maximum source: [T])
    {
        self.init(source: source){return $0 > $1;}
    }
}

//MARK: extension PriorityQueue: CollectionType
extension PriorityQueue: CollectionType {
    public var startIndex: Int{return self.source.startIndex;}
    public var endIndex: Int{return self.source.endIndex;}
    public var count: Int{return self.source.count;}
    public subscript(position: Int) -> T{
        return self.source[position];
    }
}