//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation



//MARK: PriorityQueueType
public protocol PriorityQueueType: Collection{
    
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
    
    ///shifting
    let shifting: PQShifting<Source>;
    
    ///Init
    public init(source: Source, forkCount: Int, isOrderedBefore: @escaping (T, T) -> Bool){
        self.source = source;
        self.shifting = PQShifting<Source>(isOrderedBefore: isOrderedBefore, forkCount: forkCount);
        self.source = shifting.build(source: source);
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
        source = shifting.shift(up: source.count - 1, of: source);
    }
    
    ///Pop and remove best element
    mutating public func popBest() -> T? {
        guard !source.isEmpty else {return nil;}
        guard source.count > 1 else{return source.removeLast();}
        let first = source[0];
        source[0] = source.removeLast();
        source = shifting.shift(down: 0, of: source);
        return first;
    }
    
    ///Replace element at index
    mutating public func replace(newValue: T, at index: Int) {
        source[index] = newValue;
        source = shifting.shift(auto: index, of: source);
    }
}
//MARK: PriorityQueue.heap -- Return Heap
extension PriorityQueue {
    ///Source Type
    public typealias Source = [T];
    
    ///Return heap
    public static func heap(_ source: Source, isOrderedBefore: @escaping (T, T) -> Bool) -> PriorityQueue{
        return PriorityQueue<T>.init(source: source, forkCount: 2, isOrderedBefore: isOrderedBefore);
    }
    
    ///Return heap
    public static func heap(_ isOrderedBefore: @escaping (T, T) -> Bool) -> PriorityQueue{
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
extension PriorityQueue: Collection {
    public var count: Int{return source.count;}
    public var startIndex: Int{return source.startIndex;}
    public var endIndex: Int{return source.endIndex;}
    public subscript(index: Int) -> T {return source[index];}
    public func index(after i: Int) -> Int {return i + 1;}
}





//MARK: PQShifting
public struct PQShifting<T: MutableCollection> {
    
    ///is order before
    let iob: (T.Iterator.Element, T.Iterator.Element) -> Bool;
    
    ///fork count
    let forkCount: T.IndexDistance;
    
    ///isOrderedBefore: compare function
    ///forkCount: max fork count - 2.4.8....
    public init(isOrderedBefore: @escaping (T.Iterator.Element, T.Iterator.Element) -> Bool,
                forkCount: T.IndexDistance = 2) {
        self.iob = isOrderedBefore;
        self.forkCount = forkCount;
    }
}
extension PQShifting {
    ///parent index of index
    func parentIndexOf(_ index: T.Index, source: T) -> T.Index{
        let sIndex = source.startIndex;
        let distance = source.distance(from: sIndex, to: index);
        let pDistance = (distance - 1) / forkCount;
        return source.index(sIndex, offsetBy: pDistance);
    }
    
    ///child index of index
    func childIndexOf(_ index: T.Index, source: T) -> T.Index {
        let sIndex = source.startIndex;
        let distance = source.distance(from: sIndex, to: index);
        let cDistance = distance * forkCount + 1;
        return source.index(sIndex, offsetBy: cDistance);
    }
    
    
    ///Shift up at index
    public func shift(up index: T.Index, of source: T) -> T {
        let sIndex = source.startIndex;
        guard index > sIndex else {
            return source;
        }
        
        var source = source;
        let shiftElement = source[index];
        var shiftIndex = index;
        repeat{
            let pIndex = parentIndexOf(shiftIndex, source: source);
            guard iob(shiftElement, source[pIndex]) else {
                break;
            }
            swap(&source[shiftIndex], &source[pIndex])
            shiftIndex = pIndex;
        }while shiftIndex > sIndex
        return source;
    }
    
    ///shift down at index
    public func shift(down index: T.Index, of source: T) -> T {
        var source = source;
        var pIndex = index;
        let eIndex = source.endIndex;
        repeat{
            var shiftIndex = pIndex;
            var cIndex = childIndexOf(shiftIndex, source: source);
            let ceIndex = min(source.index(cIndex, offsetBy: forkCount), eIndex);
            
            while ceIndex > cIndex{
                if iob(source[cIndex], source[shiftIndex]) {
                    shiftIndex = cIndex;
                }
                cIndex = source.index(after: cIndex);
            }
            
            guard shiftIndex != pIndex else {
                break;
            }
            swap(&source[pIndex], &source[shiftIndex])
            pIndex = shiftIndex;
        }while true;
        return source;
    }
    
    ///Auto shift element at index
    public func shift(auto index: T.Index, of source: T) -> T {
        let sIndex = source.startIndex;
        guard index >= sIndex else {
            return source;
        }
        
        let pIndex = parentIndexOf(index, source: source);
        return iob(source[index], source[pIndex]) ?
            shift(up: index, of: source)
            :
            shift(down: index, of: source);
    }
    
    ///Build
    public func build(source: T) -> T {
        guard !source.isEmpty else {
            return source;
        }
        
        let sIndex = source.startIndex;
        let eIndex = source.index(source.endIndex, offsetBy: -1);
        var index = parentIndexOf(eIndex, source: source);
        
        var source = source;
        while index >= sIndex{
            source = shift(down: index, of: source);
            index = source.index(index, offsetBy: -1);
        }
        return source;
    }
}


