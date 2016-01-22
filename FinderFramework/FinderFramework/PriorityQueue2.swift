//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation


public protocol PriorityQueueConvertible: MutableCollectionType{
    
    ///is ordered before
    var isOrderedBefore: (Generator.Element, Generator.Element) -> Bool{get}
    
    ///return branch size
    var branchSize: Index.Distance{get}
    
    ///return trunk index of index
    ///if trunk index < source.startIndex return nil otherwise return trunk index
    func trunkIndexOf(index: Index) -> Index
    
    ///return branch index of index
    ///if branch index < source.endIndex return branch index otherwise return nil
    func branchIndexOf(index: Index) -> Index
}
///extension internal
extension PriorityQueueConvertible {
    ///return trunk index of index
    ///if trunk index < source.startIndex return nil otherwise return trunk index
    public func trunkIndexOf(index: Index) -> Index {
        let d = self.startIndex.distanceTo(index);
        let d2 = (d - 1) / self.branchSize;
        return self.startIndex.advancedBy(d2);
    }

    ///return branch index of index
    ///if branch index < source.endIndex return branch index otherwise return nil
    public func branchIndexOf(index: Index) -> Index {
        let d = self.startIndex.distanceTo(index);
        let d2 = d * self.branchSize + 1;
        return self.startIndex.advancedBy(d2);
    }

    ///shift up at index
    public mutating func shiftUp(atIndex: Index) {
        let shiftElement = self[atIndex];
        var shiftIndex = atIndex;
        let sIndex = self.startIndex;
        repeat{
            let trunkIndex = trunkIndexOf(shiftIndex);
            guard sIndex.distanceTo(trunkIndex) >= 0
                && isOrderedBefore(shiftElement, self[trunkIndex]) else {break;}
            self[shiftIndex] = self[trunkIndex];
            self[trunkIndex] = shiftElement;
            shiftIndex = trunkIndex;
        }while true
    }

    ///shift down at index
    public mutating func shiftDown(atIndex: Index) {
        let shiftElement = self[atIndex];
        var trunkIndex = atIndex;
        let eIndex = self.endIndex;
        repeat{
            var branchIndex = branchIndexOf(trunkIndex);
            var shiftIndex = trunkIndex;
            let bIndex = branchIndex;
            while branchIndex.distanceTo(eIndex) > 0
                && bIndex.distanceTo(branchIndex) < branchSize {
                if isOrderedBefore(self[branchIndex], self[shiftIndex]) {
                    shiftIndex = branchIndex
                }
                branchIndex = branchIndex.successor();
            }

            guard shiftIndex != trunkIndex else{break;}
            self[trunkIndex] = self[shiftIndex];
            self[shiftIndex] = shiftElement;
            trunkIndex = shiftIndex;
        }while true;
    }

    ///auto shift element at index
    public mutating func autoShift(atIndex: Index) {
        let trunkIndex = trunkIndexOf(atIndex);
        guard startIndex.distanceTo(trunkIndex) >= 0 else {
            self.shiftDown(atIndex);
            return;
        }
        self.isOrderedBefore(self[atIndex], self[trunkIndex]) ? shiftUp(atIndex) : shiftDown(atIndex);
    }
}






///MARK: == PriorityQueue ==
public struct PriorityQueue2<T>: PriorityQueueConvertible {
    
    public typealias Index = Int;
    
    ///source
    public internal(set) var source: [T];
    
    ///is ordered before
    public let isOrderedBefore: (T, T) -> Bool;
    
    ///branch size
    public let branchSize: Int;
    
    ///init
    public init(branchSize: Int, source: [T], _ isOrderedBefore: (T, T) -> Bool) {
        self.branchSize = branchSize;
        self.source = source;
        self.isOrderedBefore = isOrderedBefore;
        self.build(source);
    }
    
    ///init binary queue
    public init(binary source: [T], isOrderedBefore: (T, T) -> Bool){
        self.init(branchSize: 2, source: source, isOrderedBefore);
    }
}
///extension public
extension PriorityQueue2{
    //append element and resort
    mutating public func insert(element: T) {
        self.source.append(element);
        self.shiftUp(self.source.count - 1);
    }

    //return(and remove) first element and resort
    mutating public func popBest() -> T? {
        if(self.source.isEmpty){return nil;}
        let first = self[0];
        let end = self.source.removeLast();
        guard !self.source.isEmpty else{return first;}
        self[0] = end;
        self.shiftDown(0);
        return first;
    }

    ///replace element at index
    mutating public func replace(element: T, at index: Int) {
        self[index] = element;
        self.autoShift(index);
    }

    ///build source
    mutating public func build(s: [T]) {
        self.source = s;
        var index = self.trunkIndexOf(self.source.count - 1);
        while index > -1{
            self.shiftDown(index);
            index -= 1;
        }
    }
    
    
    
    
    
    
    ///return trunk index of index
    ///if trunk index < source.startIndex return nil otherwise return trunk index
    public func trunkIndexOf(index: Index) -> Index {
        let d = self.startIndex.distanceTo(index);
        let d2 = (d - 1) / self.branchSize;
        return self.startIndex.advancedBy(d2);
    }
    
    ///return branch index of index
    ///if branch index < source.endIndex return branch index otherwise return nil
    public func branchIndexOf(index: Index) -> Index {
        let d = self.startIndex.distanceTo(index);
        let d2 = d * self.branchSize + 1;
        return self.startIndex.advancedBy(d2);
    }
    
    ///shift up at index
    public mutating func shiftUp(atIndex: Index) {
        let shiftElement = self[atIndex];
        var shiftIndex = atIndex;
        let sIndex = self.startIndex;
        repeat{
            let trunkIndex = trunkIndexOf(shiftIndex);
            guard sIndex.distanceTo(trunkIndex) >= 0
                && isOrderedBefore(shiftElement, self[trunkIndex]) else {break;}
            self[shiftIndex] = self[trunkIndex];
            self[trunkIndex] = shiftElement;
            shiftIndex = trunkIndex;
        }while true
    }
    
    ///shift down at index
    public mutating func shiftDown(atIndex: Index) {
        let shiftElement = self[atIndex];
        var trunkIndex = atIndex;
        let eIndex = self.endIndex;
        repeat{
            var branchIndex = branchIndexOf(trunkIndex);
            var shiftIndex = trunkIndex;
            let bIndex = branchIndex;
            while branchIndex.distanceTo(eIndex) > 0
                && bIndex.distanceTo(branchIndex) < branchSize {
                    if isOrderedBefore(self[branchIndex], self[shiftIndex]) {
                        shiftIndex = branchIndex
                    }
                    branchIndex = branchIndex.successor();
            }
            
            guard shiftIndex != trunkIndex else{break;}
            self[trunkIndex] = self[shiftIndex];
            self[shiftIndex] = shiftElement;
            trunkIndex = shiftIndex;
        }while true;
    }
    
    ///auto shift element at index
    public mutating func autoShift(atIndex: Index) {
        let trunkIndex = trunkIndexOf(atIndex);
        guard startIndex.distanceTo(trunkIndex) >= 0 else {
            self.shiftDown(atIndex);
            return;
        }
        self.isOrderedBefore(self[atIndex], self[trunkIndex]) ? shiftUp(atIndex) : shiftDown(atIndex);
    }
}
///extension where T: Comparable
extension PriorityQueue2 where T: Comparable {
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
extension PriorityQueue2: CollectionType {
    public var startIndex: Int{return self.source.startIndex;}
    public var endIndex: Int{return self.source.endIndex;}
    public subscript(position: Int) -> T{
        set{
            self.source[position] = newValue;
        }
        get{
            return self.source[position];
        }
    }
}





