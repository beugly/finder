//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation

//MARK: == PriorityQueueConvertible ==
public protocol PriorityQueueSourceConvertible: SequenceType{
    
    ///set get element at position;
    ///position range: [0, count)
    subscript(position: Int) -> Generator.Element{get set}
    
    ///element count
    var count: Int{get}
}

//MARK: == PriorityQueueSourceWrapper ==
//public struct PriorityQueueSourceWrapper<T: PriorityQueueSourceConvertible>{
public struct PriorityQueueSourceWrapper<T: PriorityQueueSourceConvertible>{
    ///source
    public internal(set) var source: T;
    
    ///is ordered before
    public let isOrderedBefore: (T.Generator.Element, T.Generator.Element) -> Bool;
    
    ///branch size
    public let branchSize: Int;
    
    ///init
    public init(source: T, branchSize: Int, isOrderedBefore: (T.Generator.Element, T.Generator.Element) -> Bool){
        self.source = source;
        self.branchSize = branchSize;
        self.isOrderedBefore = isOrderedBefore;
        self.rebuild();
    }
}
extension PriorityQueueSourceWrapper {
    ///return trunk index of index
    ///if trunk index < source.startIndex return nil otherwise return trunk index
    public func trunkIndexOf(index: Int) -> Int {
        return (index - 1) / self.branchSize;
    }
    
    ///return branch index of index
    ///if branch index < source.endIndex return branch index otherwise return nil
    public func branchIndexOf(index: Int) -> Int {
        return index * self.branchSize + 1;
    }
    
    ///shift up at index
    public mutating func shiftUp(atIndex: Int) {
        let shiftElement = self.source[atIndex];
        var shiftIndex = atIndex;
        repeat{
            let trunkIndex = trunkIndexOf(shiftIndex);
            guard trunkIndex >= 0
                && isOrderedBefore(shiftElement, self.source[trunkIndex]) else {break;}
            self.source[shiftIndex] = self.source[trunkIndex];
            self.source[trunkIndex] = shiftElement;
            shiftIndex = trunkIndex;
        }while true
    }
    
    ///shift down at index
    public mutating func shiftDown(atIndex: Int) {
        let shiftElement = self.source[atIndex];
        var trunkIndex = atIndex;
        let c = self.source.count;
        repeat{
            var branchIndex = branchIndexOf(trunkIndex);
            var shiftIndex = trunkIndex;
            let bIndex = branchIndex;
            while branchIndex < c
                && branchIndex - bIndex < branchSize {
                    if isOrderedBefore(self.source[branchIndex], self.source[shiftIndex]) {
                        shiftIndex = branchIndex
                    }
                    branchIndex += 1;
            }
            
            guard shiftIndex != trunkIndex else{break;}
            self.source[trunkIndex] = self.source[shiftIndex];
            self.source[shiftIndex] = shiftElement;
            trunkIndex = shiftIndex;
        }while true;
    }
    
    ///auto shift element at index
    public mutating func autoShift(atIndex: Int) {
        let trunkIndex = trunkIndexOf(atIndex);
        guard trunkIndex >= 0 else {
            self.shiftDown(atIndex);
            return;
        }
        self.isOrderedBefore(self.source[atIndex], self.source[trunkIndex]) ? shiftUp(atIndex) : shiftDown(atIndex);
    }
    
    ///rebuild source
    mutating public func rebuild() {
        var index = self.trunkIndexOf(self.source.count - 1);
        while index > -1{
            self.shiftDown(index);
            index -= 1;
        }
    }
}

///extension array
extension Array: PriorityQueueSourceConvertible{}
///MARK: == PriorityQueue ==
public struct PriorityQueue2<T> {
    
    ///source wrapper
    public internal(set) var wrapper: PriorityQueueSourceWrapper<[T]>
    
    ///init
    public init(branchSize: Int, source: [T], _ isOrderedBefore: (T, T) -> Bool) {
        self.wrapper = PriorityQueueSourceWrapper(source: source, branchSize: branchSize, isOrderedBefore: isOrderedBefore);
    }
    
    ///init binary queue
    public init(binary source: [T], _ isOrderedBefore: (T, T) -> Bool){
        self.init(branchSize: 2, source: source, isOrderedBefore);
    }
}
///extension public
extension PriorityQueue2{
    ///Return source(get)
    ///Set source and rebuild priority queue (set)
    public var source: [T]{
        set{
            self.wrapper.source = newValue;
            self.wrapper.rebuild();
        }
        get{
            return self.wrapper.source;
        }
    }
    
    //append element and resort
    mutating public func insert(element: T) {
        self.wrapper.source.append(element);
        self.wrapper.shiftUp(self.wrapper.source.count - 1);
    }

    //return(and remove) first element and resort
    mutating public func popBest() -> T? {
        if(self.wrapper.source.isEmpty){return nil;}
        let first = self.wrapper.source[0];
        let end = self.wrapper.source.removeLast();
        guard !self.wrapper.source.isEmpty else{return first;}
        self.wrapper.source[0] = end;
        self.wrapper.shiftDown(0);
        return first;
    }

    ///replace element at index
    mutating public func replace(element: T, at index: Int) {
        self.wrapper.source[index] = element;
        self.wrapper.autoShift(index);
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
    public var startIndex: Int{return self.wrapper.source.startIndex;}
    public var endIndex: Int{return self.wrapper.source.endIndex;}
    public var count: Int{return self.wrapper.source.count;}
    public subscript(position: Int) -> T{
        return self.wrapper.source[position];
    }
}



//public protocol PriorityQueueConvertible: MutableCollectionType{
//
//    ///is ordered before
//    var isOrderedBefore: (Generator.Element, Generator.Element) -> Bool{get}
//
//    ///return branch size
//    var branchSize: Index.Distance{get}
//
//    ///return trunk index of index
//    ///if trunk index < source.startIndex return nil otherwise return trunk index
//    func trunkIndexOf(index: Index) -> Index
//
//    ///return branch index of index
//    ///if branch index < source.endIndex return branch index otherwise return nil
//    func branchIndexOf(index: Index) -> Index
//
//    ///shift up at index
//    mutating func shiftUp(atIndex: Index)
//
//    ///shift down at index
//    mutating func shiftDown(atIndex: Index)
//
//    ///auto shift element at index
//    mutating func autoShift(atIndex: Index)
//}
/////extension internal
//extension PriorityQueueConvertible {
//
//    ///return trunk index of index
//    ///if trunk index < source.startIndex return nil otherwise return trunk index
//    public func trunkIndexOf(index: Index) -> Index {
//        let d = self.startIndex.distanceTo(index);
//        let d2 = (d - 1) / self.branchSize;
//        return self.startIndex.advancedBy(d2);
//    }
//
//    ///return branch index of index
//    ///if branch index < source.endIndex return branch index otherwise return nil
//    public func branchIndexOf(index: Index) -> Index {
//        let d = self.startIndex.distanceTo(index);
//        let d2 = d * self.branchSize + 1;
//        return self.startIndex.advancedBy(d2);
//    }
//
//    ///shift up at index
//    public mutating func shiftUp(atIndex: Index) {
//        let shiftElement = self[atIndex];
//        var shiftIndex = atIndex;
//        let sIndex = self.startIndex;
//        repeat{
//            let trunkIndex = trunkIndexOf(shiftIndex);
//            guard sIndex.distanceTo(trunkIndex) >= 0
//                && isOrderedBefore(shiftElement, self[trunkIndex]) else {break;}
//            self[shiftIndex] = self[trunkIndex];
//            self[trunkIndex] = shiftElement;
//            shiftIndex = trunkIndex;
//        }while true
//    }
//
//    ///shift down at index
//    public mutating func shiftDown(atIndex: Index) {
//        let shiftElement = self[atIndex];
//        var trunkIndex = atIndex;
//        let eIndex = self.endIndex;
//        repeat{
//            var branchIndex = branchIndexOf(trunkIndex);
//            var shiftIndex = trunkIndex;
//            let bIndex = branchIndex;
//            while branchIndex.distanceTo(eIndex) > 0
//                && bIndex.distanceTo(branchIndex) < branchSize {
//                if isOrderedBefore(self[branchIndex], self[shiftIndex]) {
//                    shiftIndex = branchIndex
//                }
//                branchIndex = branchIndex.successor();
//            }
//
//            guard shiftIndex != trunkIndex else{break;}
//            self[trunkIndex] = self[shiftIndex];
//            self[shiftIndex] = shiftElement;
//            trunkIndex = shiftIndex;
//        }while true;
//    }
//
//    ///auto shift element at index
//    public mutating func autoShift(atIndex: Index) {
//        let trunkIndex = trunkIndexOf(atIndex);
//        guard startIndex.distanceTo(trunkIndex) >= 0 else {
//            self.shiftDown(atIndex);
//            return;
//        }
//        self.isOrderedBefore(self[atIndex], self[trunkIndex]) ? shiftUp(atIndex) : shiftDown(atIndex);
//    }
//}