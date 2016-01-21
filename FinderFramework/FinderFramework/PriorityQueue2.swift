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
    
    ///return trunk index of $0
    var trunkIndexOf: Index -> Index{get}
    
    ///return branch index of $0
    var branchIndexOf: Index -> Index{get}
    
    ///return branch size
    var branchSize: Index.Distance{get}
}
///extension internal
extension PriorityQueueConvertible {
//    ///return trunk index of index
//    ///if trunk index < source.startIndex return nil otherwise return trunk index
//    func trunkIndexOf(index: Int) -> Int? {
//        let i = (index - 1) / self.branchSize;
//        return i < 0 ? .None : i;
//    }
//
//    ///return branch index of index
//    ///if branch index < source.endIndex return branch index otherwise return nil
//    func branchIndexOf(index: Int) -> Int? {
//        let i = index * self.branchSize + 1;
//        return i < self.count ? i : .None;
//    }

    ///shift up of index
    public mutating func shiftUp(ofIndex: Index) {
        let shiftElement = self[ofIndex];
        var shiftIndex = ofIndex;
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

    ///shift down of index
    public mutating func shiftDown(ofIndex: Index) {
        let shiftElement = self[ofIndex];
        var trunkIndex = ofIndex;
        let eIndex = self.endIndex;
        repeat{
            var branchIndex = branchIndexOf(trunkIndex);
            var shiftIndex = trunkIndex;
            let bIndex = branchIndex;
            while branchIndex.distanceTo(eIndex) > 0
                && bIndex.distanceTo(branchIndex) < branchSize{
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
    public mutating func autoShiftAt(index: Index) {
        let trunkIndex = trunkIndexOf(index);
        guard startIndex.distanceTo(trunkIndex) >= 0 else {
            self.shiftDown(index);
            return;
        }
        self.isOrderedBefore(self[index], self[trunkIndex]) ? shiftUp(index) : shiftDown(index);
    }
}






/////MARK: == PriorityQueue ==
//public struct PriorityQueue<T> {
//    ///source
//    public internal(set) var source: [T];
//    
//    ///is ordered before
//    let isOrderedBefore: (T, T) -> Bool;
//    
//    ///branch size
//    let branchSize: Int;
//    
//    ///init
//    public init(branchSize: Int, source: [T], _ isOrderedBefore: (T, T) -> Bool) {
//        self.branchSize = branchSize;
//        self.source = source;
//        self.isOrderedBefore = isOrderedBefore;
//        self.build(source);
//    }
//    
//    ///init binary queue
//    public init(binary source: [T], isOrderedBefore: (T, T) -> Bool){
//        self.init(branchSize: 2, source: source, isOrderedBefore);
//    }
//}
/////extension internal
//extension PriorityQueue {
//    ///return trunk index of index
//    ///if trunk index < source.startIndex return nil otherwise return trunk index
//    func trunkIndexOf(index: Int) -> Int? {
//        let i = (index - 1) / self.branchSize;
//        return i < 0 ? .None : i;
//    }
//    
//    ///return branch index of index
//    ///if branch index < source.endIndex return branch index otherwise return nil
//    func branchIndexOf(index: Int) -> Int? {
//        let i = index * self.branchSize + 1;
//        return i < self.count ? i : .None;
//    }
//    
//    ///shift up of index
//    mutating func shiftUp(ofIndex: Int) {
//        let shiftElement = self[ofIndex];
//        var shiftIndex = ofIndex;
//        
//        repeat{
//            guard let trunkIndex = trunkIndexOf(shiftIndex) else {break;}
//            let trunkElement = self[trunkIndex];
//            
//            guard isOrderedBefore(shiftElement, trunkElement) else {break;}
//            self[shiftIndex] = self[trunkIndex];
//            self[trunkIndex] = shiftElement;
//            shiftIndex = trunkIndex;
//        }while true
//    }
//    
//    ///shift down of index
//    mutating func shiftDown(ofIndex: Int) {
//        let shiftElement = self[ofIndex];
//        var trunkIndex = ofIndex;
//        let eIndex = self.endIndex;
//        repeat{
//            guard var branchIndex = branchIndexOf(trunkIndex) else {break;}
//            var shiftIndex = trunkIndex;
//            let bIndex = branchIndex;
//            repeat{
//                if isOrderedBefore(self[branchIndex], self[shiftIndex]) {
//                    shiftIndex = branchIndex
//                }
//                branchIndex += 1;
//                if branchIndex >= eIndex || branchIndex - bIndex >= branchSize {break;}
//            }while true
//            
//            guard shiftIndex != trunkIndex else{break;}
//            self[trunkIndex] = self[shiftIndex];
//            self[shiftIndex] = shiftElement;
//            trunkIndex = shiftIndex;
//        }while true;
//    }
//    
//    ///shift element at index
//    mutating func shiftAt(index: Int) {
//        guard let tindex = trunkIndexOf(index)else{
//            self.shiftDown(index);
//            return;
//        }
//        self.isOrderedBefore(self[index], self[tindex]) ? shiftUp(index) : shiftDown(index);
//    }
//}
/////extension public
//extension PriorityQueue{
//    //append element and resort
//    mutating public func insert(element: T) {
//        self.source.append(element);
//        self.shiftUp(self.count - 1);
//    }
//    
//    //return(and remove) first element and resort
//    mutating public func popBest() -> T? {
//        if(self.isEmpty){return nil;}
//        let first = self[0];
//        let end = self.source.removeLast();
//        guard !self.isEmpty else{return first;}
//        self[0] = end;
//        self.shiftDown(0);
//        return first;
//    }
//    
//    ///replace element at index
//    mutating public func replace(element: T, at index: Int) {
//        self[index] = element;
//        self.shiftAt(index);
//    }
//    
//    ///build source
//    mutating public func build(s: [T]) {
//        self.source = s;
//        let lastIndex = self.count - 1;
//        guard var index = self.trunkIndexOf(lastIndex) else {return;}
//        repeat{
//            self.shiftDown(index);
//            index -= 1;
//        }while index >= 0
//    }
//}
/////extension where T: Comparable
//extension PriorityQueue where T: Comparable {
//    //minimum heap
//    public init(minimum source: Array<T>, branchSize: Int = 2){
//        self.init(branchSize: branchSize, source: source){return $0 < $1;}
//    }
//    
//    //maximum heap
//    public init(maximum source: Array<T>, branchSize: Int = 2)
//    {
//        self.init(branchSize: branchSize, source: source){return $0 > $1;}
//    }
//}
/////extension CollectionType
//extension PriorityQueue: CollectionType {
//    public var startIndex: Int{return self.source.startIndex;}
//    public var endIndex: Int{return self.source.endIndex;}
//    public var count: Int{return self.source.count;}
//    public subscript(position: Int) -> T{
//        set{
//            self.source[position] = newValue;
//        }
//        get{
//            return self.source[position];
//        }
//    }
//}
//
//
//
//
//
//
//
///////extension internal
////extension PriorityQueue {
////    ///return trunk index of index
////    ///if trunk index < source.startIndex return nil otherwise return trunk index
////    func trunkIndexOf(index: Int) -> Int? {
////        let i = (index - 1) / self.branchSize;
////        return i < 0 ? .None : i;
////    }
////
////    ///return branch index of index
////    ///if branch index < source.endIndex return branch index otherwise return nil
////    func branchIndexOf(index: Int) -> Int? {
////        let i = index * self.branchSize + 1;
////        return i < source.count ? i : .None;
////    }
////
////    ///shift up of index
////    mutating func shiftUp(ofIndex: Int) {
////        let shiftElement = source[ofIndex];
////        var shiftIndex = ofIndex;
////
////        repeat{
////            guard let trunkIndex = trunkIndexOf(shiftIndex) else {break;}
////            let trunkElement = source[trunkIndex];
////
////            guard isOrderedBefore(shiftElement, trunkElement) else {break;}
////            source[shiftIndex] = source[trunkIndex];
////            source[trunkIndex] = shiftElement;
////            shiftIndex = trunkIndex;
////        }while true
////    }
////
////    ///shift down of index
////    mutating func shiftDown(ofIndex: Int) {
////        let shiftElement = source[ofIndex];
////        var trunkIndex = ofIndex;
////        let eIndex = source.endIndex;
////        repeat{
////            guard var branchIndex = branchIndexOf(trunkIndex) else {break;}
////            var shiftIndex = trunkIndex;
////            let bIndex = branchIndex;
////            repeat{
////                if isOrderedBefore(source[branchIndex], source[shiftIndex]) {
////                    shiftIndex = branchIndex
////                }
////                branchIndex += 1;
////                if branchIndex >= eIndex || branchIndex - bIndex >= branchSize {break;}
////            }while true
////
////            guard shiftIndex != trunkIndex else{break;}
////            source[trunkIndex] = source[shiftIndex];
////            source[shiftIndex] = shiftElement;
////            trunkIndex = shiftIndex;
////        }while true;
////    }
////
////    ///shift element at index
////    mutating func shiftAt(index: Int) {
////        guard let tindex = trunkIndexOf(index)else{
////            self.shiftDown(index);
////            return;
////        }
////        self.isOrderedBefore(source[index], source[tindex]) ? shiftUp(index) : shiftDown(index);
////    }
////}
///////extension public
////extension PriorityQueue{
////    //append element and resort
////    mutating public func insert(element: T) {
////        self.source.append(element);
////        self.shiftUp(self.source.count - 1);
////    }
////
////    //return(and remove) first element and resort
////    mutating public func popBest() -> T? {
////        if(self.source.isEmpty){return nil;}
////        let first = self.source[0];
////        let end = self.source.removeLast();
////        guard !self.source.isEmpty else{return first;}
////        self.source[0] = end;
////        self.shiftDown(0);
////        return first;
////    }
////
////    ///replace element at index
////    mutating public func replace(element: T, at index: Int) {
////        self.source[index] = element;
////        self.shiftAt(index);
////    }
////
////    ///build source
////    mutating public func build(s: [T]) {
////        self.source = s;
////        let lastIndex = self.source.count - 1;
////        guard var index = self.trunkIndexOf(lastIndex) else {return;}
////        repeat{
////            self.shiftDown(index);
////            index -= 1;
////        }while index >= 0
////    }
////}
///////extension where T: Comparable
////extension PriorityQueue where T: Comparable {
////    //minimum heap
////    public init(minimum source: Array<T>, branchSize: Int = 2){
////        self.init(branchSize: branchSize, source: source){return $0 < $1;}
////    }
////
////    //maximum heap
////    public init(maximum source: Array<T>, branchSize: Int = 2)
////    {
////        self.init(branchSize: branchSize, source: source){return $0 > $1;}
////    }
////}
///////extension CollectionType
////extension PriorityQueue: CollectionType {
////    public var startIndex: Int{return self.source.startIndex;}
////    public var endIndex: Int{return self.source.endIndex;}
////    public subscript(position: Int) -> T{
////        return self.source[position];
////    }
////}





