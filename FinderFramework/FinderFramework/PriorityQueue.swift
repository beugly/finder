//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation

///MARK: PriorityQueue
public struct PriorityQueue<T> {
    ///source
    public private(set) var source: [T];
    
    ///max heap (>) OR min heap (<)
    private let isOrderedBefore: (T, T) -> Bool;
    
    ///Init
    public init(source: [T], isOrderedBefore: (T, T) -> Bool) {
        self.isOrderedBefore = isOrderedBefore;
        self.source = source;
        self.rebuild();
    }
    
    ///Init
    public init(isOrderedBefore: (T, T) -> Bool) {
        self.init(source: [], isOrderedBefore: isOrderedBefore);
    }
}

//MARK: extension PriorityQueue internal
extension PriorityQueue {
    
    ///Return parent index of child index
    func parentIndexOf(index: Int) -> Int {
        return (index - 1) >> 1;
    }
    
    ///Return min child index of parent index
    func childIndexOf(index: Int) -> Int {
        return index << 1 + 1;
    }
    
    ///Shift up at index
    mutating func shiftUp(atIndex: Int) {
        let shiftElement = self.source[atIndex];
        var shiftIndex = atIndex;
        repeat{
            let parentIndex = parentIndexOf(shiftIndex);
            guard parentIndex >= 0
                && isOrderedBefore(shiftElement, self.source[parentIndex]) else {break;}
            swap(&source[shiftIndex], &source[parentIndex])
            shiftIndex = parentIndex;
        }while true
    }
    
    ///shift down at position
    mutating func shiftDown(atIndex: Int) {
        var parentIndex = atIndex;
        let c = self.source.count;
        repeat{
            var childIndex = childIndexOf(parentIndex);
            guard childIndex < c else {break;}
            
            var shiftIndex = parentIndex;
            if isOrderedBefore(self.source[childIndex], self.source[shiftIndex]) {
                shiftIndex = childIndex;
            }
            
            childIndex += 1;
            if childIndex < c && isOrderedBefore(self.source[childIndex], self.source[shiftIndex]) {
                shiftIndex = childIndex;
            }
            
            guard shiftIndex != parentIndex else{break;}
            swap(&source[parentIndex], &source[shiftIndex])
            parentIndex = shiftIndex;
        }while true;
    }
    
    ///Auto shift element at index
    mutating func autoShift(atIndex: Int) {
        let parentIndex = parentIndexOf(atIndex);
        guard parentIndex >= 0 else {
            self.shiftDown(atIndex);
            return;
        }
        self.isOrderedBefore(self.source[atIndex], self.source[parentIndex]) ? shiftUp(atIndex) : shiftDown(atIndex);
    }
}

//MARK: extension PriorityQueue public
extension PriorityQueue{
    
    ///Preview min OR max element
    public var preview: T? {
        return self.source.first;
    }
    
    ///Insert element
    mutating public func insert(element: T) {
        self.source.append(element);
        self.shiftUp(self.source.count - 1);
    }
    
    ///Remove best element
    mutating public func popBest() -> T? {
        guard !self.source.isEmpty else {return nil;}
        guard self.source.count > 1 else{return self.source.removeLast();}
        let first = self.source[0];
        self.source[0] = self.source.removeLast();
        self.shiftDown(0);
        return first;
    }
    
    ///Replace element at index
    mutating public func replace(atIndex: Int, newValue: T) {
        self.source[atIndex] = newValue;
        self.autoShift(atIndex);
    }
    
    ///Rebuild priority queue
    mutating public func rebuild() {
        guard self.source.count > 0 else{return;}
        var index = self.parentIndexOf(self.source.count - 1);
        while index > -1{
            self.shiftDown(index);
            index -= 1;
        }
    }
}

//MARK: extension PriorityQueue where T: Comparable
extension PriorityQueue where T: Comparable {
    ///minimum heap
    public init(minimum source: [T] = []){
        self.init(source: source){return $0 < $1;}
    }
    
    ///maximum heap
    public init(maximum source: [T] = [])
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





