//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation

//MARK: PQShiftable
public protocol PQShiftable{
    
    ///Source Type
    associatedtype Source: MutableIndexable;
    
    ///Is oridered before
    var isOrderedBefore: (Source._Element, Source._Element) -> Bool {get}
    
    ///Return parent index of child index
    func parentIndex(of index: Source.Index) -> Source.Index
    
    ///Return child indexs range of parent index
    func childIndexs(of index: Source.Index) -> Range<Source.Index>
}
////MARK: PQBuildable - shifting
//extension PQShiftable{
//    
//    ///Shift up at index
//    @warn_unused_result
//    func shift(up index: Source.Index, of source: Source) -> Source {
//        var source = source;
//        let shiftElement = source[index];
//        var shiftIndex = index;
//        let sIndex = source.startIndex;
//        repeat{
//            let pIndex = parentIndex(of: shiftIndex);
//            guard sIndex.distanceTo(pIndex) >= 0
//                && isOrderedBefore(shiftElement, source[pIndex]) else {break;}
//            swap(&source[shiftIndex], &source[pIndex])
//            shiftIndex = pIndex;
//        }while true
//        return source;
//    }
//    
//    ///shift down at index
//    @warn_unused_result
//    func shift(down index: Source.Index, of source: Source) -> Source {
//        var source = source;
//        var pIndex = index;
//        let eIndex = source.endIndex;
//        repeat{
//            var shiftIndex = pIndex;
//            let cIndexs = childIndexs(of: pIndex);
//            
//            for cIndex in cIndexs {
//                guard cIndex.distanceTo(eIndex) > 0 else {
//                    continue;
//                }
//                
//                if isOrderedBefore(source[cIndex], source[shiftIndex]) {
//                    shiftIndex = cIndex;
//                }
//            }
//            
//            guard shiftIndex != pIndex else{break;}
//            swap(&source[pIndex], &source[shiftIndex])
//            pIndex = shiftIndex;
//        }while true;
//        return source;
//    }
//    
//    ///Auto shift element at index
//    @warn_unused_result
//    func shift(auto index: Source.Index, of source: Source) -> Source {
//        let pIndex = parentIndex(of: index);
//        guard source.startIndex.distanceTo(pIndex) >= 0 else {
//            return shift(down: index, of: source);
//        }
//        
//        return isOrderedBefore(source[index], source[pIndex]) ?
//            shift(up: index, of: source)
//            :
//            shift(down: index, of: source);
//        
//    }
//    
//    ///Build
//    @warn_unused_result
//    func build(source: Source) -> Source {
//        let sIndex = source.startIndex;
//        let eIndex = source.endIndex;
//        guard sIndex.distanceTo(eIndex) > 0 else{return source;}
//        var index = parentIndex(of: eIndex.advancedBy(-1));
//        var source = source;
//        while sIndex.distanceTo(index) >= 0{
//            source = shift(down: index, of: source);
//            index = index.advancedBy(-1);
//        }
//        return source;
//    }
//}


//MARK: PriorityQueueType
public protocol PriorityQueueType: Indexable{
    
    ///Preview element
    var preview: Self._Element?{get}
    
    ///Insert element
    mutating func insert(element: Self._Element)
    
    ///Remove best element
    mutating func popBest() -> Self._Element?
    
    ///Replace element at index
    mutating func replace(newValue: Self._Element, at index: Self.Index)
}



///MARK: PriorityQueue
///If u need Heap, use static func PriorityQueue.heap(xxxxx);
public struct PriorityQueue<T> {
    ///source
    public internal(set) var source: Source;
    
    ///Compare function return is ordered before
    public let isOrderedBefore: (T, T) -> Bool;
    
    ///fork count
    public let forkCount: Int;
    
    ///Init
    init(source: Source, forkCount: Int, isOrderedBefore: (T, T) -> Bool){
        self.source = source;
        self.isOrderedBefore = isOrderedBefore;
        self.forkCount = forkCount;
        self.source = build(source);
    }
}

//MARK: extention PriorityQueue: PQBuildable
extension PriorityQueue: PQShiftable {
    ///Source Type
    public typealias Source = [T];
    
    ///Return parent index of child index
    public func parentIndex(of index: Int) -> Int {
        return (index - 1) / forkCount;
    }
    
    ///Return child indexs range of parent index
    public func childIndexs(of index: Int) -> Range<Int> {
        let i = index * forkCount + 1;
        return i ..< i + forkCount;
    }
}
//MARK: PQBuildable - shifting
extension PriorityQueue{
    ///Shift up at index
    @warn_unused_result
    func shift(up index: Source.Index, of source: Source) -> Source {
        var source = source;
        let shiftElement = source[index];
        var shiftIndex = index;
        let sIndex = source.startIndex;
        repeat{
            let pIndex = parentIndex(of: shiftIndex);
            guard sIndex.distanceTo(pIndex) >= 0
                && isOrderedBefore(shiftElement, source[pIndex]) else {break;}
            swap(&source[shiftIndex], &source[pIndex])
            shiftIndex = pIndex;
        }while true
        return source;
    }
    
    ///shift down at index
    @warn_unused_result
    func shift(down index: Source.Index, of source: Source) -> Source {
        var source = source;
        var pIndex = index;
        let eIndex = source.endIndex;
        repeat{
            var shiftIndex = pIndex;
            let cIndexs = childIndexs(of: pIndex);
            
            for cIndex in cIndexs {
                guard cIndex.distanceTo(eIndex) > 0 else {
                    continue;
                }
                
                if isOrderedBefore(source[cIndex], source[shiftIndex]) {
                    shiftIndex = cIndex;
                }
            }
            
            guard shiftIndex != pIndex else{break;}
            swap(&source[pIndex], &source[shiftIndex])
            pIndex = shiftIndex;
        }while true;
        return source;
    }
    
    ///Auto shift element at index
    @warn_unused_result
    func shift(auto index: Source.Index, of source: Source) -> Source {
        let pIndex = parentIndex(of: index);
        guard source.startIndex.distanceTo(pIndex) >= 0 else {
            return shift(down: index, of: source);
        }
        
        return isOrderedBefore(source[index], source[pIndex]) ?
            shift(up: index, of: source)
            :
            shift(down: index, of: source);
    }
    
    ///Build
    @warn_unused_result
    func build(source: Source) -> Source {
        let sIndex = source.startIndex;
        let eIndex = source.endIndex;
        guard sIndex.distanceTo(eIndex) > 0 else{return source;}
        var index = parentIndex(of: eIndex.advancedBy(-1));
        var source = source;
        while sIndex.distanceTo(index) >= 0{
            source = shift(down: index, of: source);
            index = index.advancedBy(-1);
        }
        return source;
    }
}

//MARK: extension PriorityQueue: PriorityQueueType
extension PriorityQueue: PriorityQueueType{
    
    ///Preview min OR max element
    public var preview: T? {
        return source.first;
    }
    
    ///Insert element
    mutating public func insert(element: T) {
        source.append(element);
        source = shift(up: source.count - 1, of: source);
    }
    
    ///Pop and remove best element
    mutating public func popBest() -> T? {
        guard !source.isEmpty else {return nil;}
        guard source.count > 1 else{return source.removeLast();}
        let first = source[0];
        source[0] = source.removeLast();
        source = shift(down: 0, of: source);
        return first;
    }
    
    ///Replace element at index
    mutating public func replace(newValue: T, at index: Int) {
        source[index] = newValue;
        source = shift(auto: index, of: source);
    }
}
//MARK: PriorityQueue.heap -- Return Heap
extension PriorityQueue {
    ///Return heap
    public static func heap(source: Source, isOrderedBefore: (T, T) -> Bool) -> PriorityQueue{
        return PriorityQueue<T>.init(source: source, forkCount: 2, isOrderedBefore: isOrderedBefore);
    }
    
    ///Return heap
    public static func heap(isOrderedBefore: (T, T) -> Bool) -> PriorityQueue{
        return heap([], isOrderedBefore: isOrderedBefore);
    }
}

//MARK: PriorityQueue.heap where T: Comparable
extension PriorityQueue where T: Comparable {
    ///Return minimum heap
    public static func heap(minimum source: Source) -> PriorityQueue{
        return heap(source){return $0 < $1;}
    }
    
    ///Return maximum heap
    public static func heap(maximum source: Source) -> PriorityQueue{
        return heap(source){return $0 > $1;}
    }
}

//MARK: extension PriorityQueue: CollectionType
extension PriorityQueue: CollectionType {
    public var count: Int{return source.count;}
    public var startIndex: Int{return source.startIndex;}
    public var endIndex: Int{return source.endIndex;}
    public subscript(index: Int) -> T {
        return source[index];
    }
}


////==============================================================
////==============================================================
////==============================================================
////==============================================================
////==============================================================
////==============================================================





//public struct PQHeapBuilder<T>{
//    ///max heap (>) OR min heap (<)
//    public let isOrderedBefore: (T, T) -> Bool;
//    
//    ///Init
//    public init(isOrderedBefore: (T, T) -> Bool) {
//        self.isOrderedBefore = isOrderedBefore;
//    }
//}
//extension PQHeapBuilder{
//    public typealias Source = [T]
//    
//    ///Shift up at index
//    public func shift(up index: Source.Index, inout of source: Source) {
//        let shiftElement = source[index];
//        var shiftIndex = index;
//        let startIndex = source.startIndex;
//        repeat{
//            let pIndex = parentIndex(of: shiftIndex);
//            
//            guard startIndex.distanceTo(pIndex) >= 0
//                && isOrderedBefore(shiftElement, source[pIndex]) else {break;}
//            swap(&source[shiftIndex], &source[pIndex])
//            shiftIndex = pIndex;
//        }while true
//    }
//    
//    ///shift down at index
//    public func shift(down index: Source.Index, inout of source: Source) {
//        var pIndex = index;
//        let endIndex = source.endIndex;
//        repeat{
//            var shiftIndex = pIndex;
//            let cIndexs = childIndexs(of: pIndex);
//            
//            for cIndex in cIndexs {
//                guard cIndex.distanceTo(endIndex) > 0 else {
//                    continue;
//                }
//                
//                if isOrderedBefore(source[cIndex], source[shiftIndex]) {
//                    shiftIndex = cIndex;
//                }
//            }
//            
//            guard shiftIndex != pIndex else{break;}
//            swap(&source[pIndex], &source[shiftIndex])
//            pIndex = shiftIndex;
//        }while true;
//    }
//    
//    ///Auto shift element at index
//    public func shift(auto index: Source.Index, inout of source: Source) {
//        let pIndex = parentIndex(of: index);
//        guard source.startIndex.distanceTo(pIndex) >= 0 else {
//            shift(down: index, of: &source);
//            return;
//        }
//        isOrderedBefore(source[index], source[pIndex]) ?
//            shift(up: index, of: &source) :
//            shift(down: index, of: &source);
//    }
//    
//    ///Return heap array
//    public func building(source: Source) -> Source {
//        var source = source;
//        let startIndex = source.startIndex;
//        let endIndex = source.endIndex;
//        guard startIndex.distanceTo(endIndex) > 0 else{return source;}
//        var index = parentIndex(of: endIndex.advancedBy(-1));
//        while startIndex.distanceTo(index) >= 0{
//            shift(down: index, of: &source);
//            index = index.advancedBy(-1);
//        }
//        return source;
//    }
//    
//    ///Return parent index of child index
//    public func parentIndex(of index: Int) -> Int{
//        return (index - 1) >> 1;
//    }
//    
//    ///Return child indexs range of parent index
//    public func childIndexs(of index: Int) -> Range<Int>{
//        let i = index << 1 + 1;
//        return i...i+1;
//    }
//}
//
/////MARK: PriorityQueue
//public struct PriorityQueue<T> {
//    ///source
//    public private(set) var source: [T];
//    
//    ///heap builder
//    private let builder: PQHeapBuilder<T>
//    
//    ///Init
//    public init(source: [T], isOrderedBefore: (T, T) -> Bool) {
//        self.builder = PQHeapBuilder<T>(isOrderedBefore: isOrderedBefore);
//        self.source = self.builder.building(source);
//    }
//    
//    ///Init
//    public init(isOrderedBefore: (T, T) -> Bool) {
//        self.init(source: [], isOrderedBefore: isOrderedBefore);
//    }
//}
//
////MARK: extension PriorityQueue public
//extension PriorityQueue{
//    
//    ///Preview min OR max element
//    public var preview: T? {
//        return source.first;
//    }
//    
//    ///Insert element
//    mutating public func insert(element: T) {
//        source.append(element);
//        builder.shift(up: source.count - 1, of: &source);
//    }
//    
//    ///Remove best element
//    mutating public func popBest() -> T? {
//        guard !source.isEmpty else {return nil;}
//        guard source.count > 1 else{return source.removeLast();}
//        let first = source[0];
//        source[0] = source.removeLast();
//        builder.shift(down: 0, of: &source);
//        return first;
//    }
//    
//    ///Replace element at index
//    mutating public func replace(newValue: T, at index: Int) {
//        source[index] = newValue;
//        builder.shift(auto: index, of: &source);
//    }
//    
//    ///Rebuild priority queue
//    mutating public func rebuild() {
//        self.source = builder.building(source);
//    }
//}
//
////MARK: extension PriorityQueue where T: Comparable
//extension PriorityQueue where T: Comparable {
//    ///minimum heap
//    public init(minimum source: [T]){
//        self.init(source: source){return $0 < $1;}
//    }
//    
//    ///maximum heap
//    public init(maximum source: [T])
//    {
//        self.init(source: source){return $0 > $1;}
//    }
//}
//
////MARK: extension PriorityQueue: CollectionType
//extension PriorityQueue: CollectionType {
//    public var startIndex: Int{return self.source.startIndex;}
//    public var endIndex: Int{return self.source.endIndex;}
//    public var count: Int{return self.source.count;}
//    public subscript(position: Int) -> T{
//        return self.source[position];
//    }
//}