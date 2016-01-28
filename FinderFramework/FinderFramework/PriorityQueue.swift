//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation

///MARK: == PriorityQueue ==
public struct PriorityQueue<T> {
    ///source
    private var _source: [T];
    
    ///is ordered before
    private let isOrderedBefore: (T, T) -> Bool;
    
    ///branch size
    private let branchSize: Int;
    
    ///init
    public init(branchSize: Int, source: [T], _ isOrderedBefore: (T, T) -> Bool) {
        self.branchSize = branchSize;
        self.isOrderedBefore = isOrderedBefore;
        self._source = source;
        self.rebuild();
    }
    
    ///init binary queue
    public init(binary source: [T], isOrderedBefore: (T, T) -> Bool){
        self.init(branchSize: 2, source: source, isOrderedBefore);
    }
}
///extension internal
extension PriorityQueue {
    
    ///Return source array (get)
    ///Set source array and rebuild priority queue (set)
    public var source: [T] {
        set{
            self._source = newValue;
            self.rebuild();
        }
        get{
            return self._source;
        }
    }
    
    ///return trunk position of position
    public func trunkPositionOf(position:Int) -> Int {
        return (position - 1) / self.branchSize;
    }
    
    ///return branch position of position
    public func branchPositionOf(position:Int) -> Int {
        return position  * self.branchSize + 1;
    }
    
    ///shift up at position
    public mutating func shiftUp(atPosition: Int) {
        let shiftElement = self._source[atPosition];
        var shiftIndex = atPosition;
        repeat{
            let trunkIndex = trunkPositionOf(shiftIndex);
            guard trunkIndex >= 0
                && isOrderedBefore(shiftElement, self._source[trunkIndex]) else {break;}
            self._source[shiftIndex] = self._source[trunkIndex];
            self._source[trunkIndex] = shiftElement;
            shiftIndex = trunkIndex;
        }while true
    }
    
    ///shift down at position
    public mutating func shiftDown(atPosition: Int) {
        let shiftElement = self._source[atPosition];
        var trunkIndex = atPosition;
        let c = self._source.count;
        repeat{
            var branchIndex = branchPositionOf(trunkIndex);
            var shiftIndex = trunkIndex;
            let bIndex = branchIndex;
            while branchIndex < c
                && branchIndex - bIndex < branchSize {
                    if isOrderedBefore(self._source[branchIndex], self._source[shiftIndex]) {
                        shiftIndex = branchIndex
                    }
                    branchIndex += 1;
            }
            
            guard shiftIndex != trunkIndex else{break;}
            self._source[trunkIndex] = self._source[shiftIndex];
            self._source[shiftIndex] = shiftElement;
            trunkIndex = shiftIndex;
        }while true;
    }
    
    ///auto shift element at index
    public mutating func autoShift(atPosition: Int) {
        let trunkIndex = trunkPositionOf(atPosition);
        guard trunkIndex >= 0 else {
            self.shiftDown(atPosition);
            return;
        }
        self.isOrderedBefore(self._source[atPosition], self._source[trunkIndex]) ? shiftUp(atPosition) : shiftDown(atPosition);
    }
    
    ///rebuild source
    public mutating func rebuild() {
        guard self._source.count > 0 else{return;}
        var index = self.trunkPositionOf(self._source.count - 1);
        while index > -1{
            self.shiftDown(index);
            index -= 1;
        }
    }
}
///extension public
extension PriorityQueue{
    //append element and resort
    mutating public func insert(element: T) {
        self._source.append(element);
        self.shiftUp(self._source.count - 1);
    }
    
    //return(and remove) first element and resort
    mutating public func popBest() -> T? {
        if(self._source.isEmpty){return nil;}
        let first = self._source[0];
        let end = self._source.removeLast();
        guard !self._source.isEmpty else{return first;}
        self._source[0] = end;
        self.shiftDown(0);
        return first;
    }
    
    ///replace element at index
    mutating public func replace(element: T, at position: Int) {
        self._source[position] = element;
        self.autoShift(position);
    }
}
///extension where T: Comparable
extension PriorityQueue where T: Comparable {
    //minimum heap
    public init(minimum source: Array<T>, branchSize: Int = 2){
        self.init(branchSize: branchSize, source: source){return $0 < $1;}
    }
    
    //maximum heap
    public init(maximum source: Array<T>, branchSize: Int = 2)
    {
        self.init(branchSize: branchSize, source: source){return $0 > $1;}
    }
}
///extension CollectionType
extension PriorityQueue: CollectionType {
    public var startIndex: Int{return self._source.startIndex;}
    public var endIndex: Int{return self._source.endIndex;}
    public var count: Int{return self._source.count;}
    public subscript(position: Int) -> T{
        return self._source[position];
    }
}





