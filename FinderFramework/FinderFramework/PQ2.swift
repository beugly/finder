////
////  PQ2.swift
////  FinderFramework
////
////  Created by xifangame on 16/9/14.
////  Copyright © 2016年 xifangame. All rights reserved.
////
//
//import Foundation
//
//
//
//
//
//
////public struct PQHeapBuilder<Source: MutableIndexable where Source.Index == Int>{
////    ///max heap (>) OR min heap (<)
////    public let isOrderedBefore: (T, T) -> Bool;
////    
////    
////    ///Init
////    public init(isOrderedBefore: (T, T) -> Bool) {
////        self.isOrderedBefore = isOrderedBefore;
////    }
////    
////    ///Return parent index of child index
////    public func parentIndex(of index: Int) -> Int{
////        return (index - 1) >> 1;
////    }
////    
////    ///Return child indexs range of parent index
////    public func childIndexs(of index: Int) -> Range<Int>{
////        let i = index << 1 + 1;
////        return i...i+1;
////    }
////}
////
////
///////MARK: PriorityQueue
////public struct PriorityQueue2<T> {
////    
////    public typealias Source = [T];
////    
////    ///source
////    public private(set) var source: Source;
////    
////    ///heap builder
////    private let builder: PQHeapBuilder<Source>
////    
////    ///Init
////    public init(source: [T], isOrderedBefore: (T, T) -> Bool) {
////        self.builder = PQHeapBuilder<Source>(isOrderedBefore: isOrderedBefore);
////        self.source = self.builder.building(source);
////    }
////    
////    ///Init
////    public init(isOrderedBefore: (T, T) -> Bool) {
////        self.init(source: [], isOrderedBefore: isOrderedBefore);
////    }
////}
//
//
//public struct PQHeapBuilder<Source: MutableCollection>{
//    ///max heap (>) OR min heap (<)
//    public let isOrderedBefore: (Source._Element, Source._Element) -> Bool;
//    
//    public let parentIndex: (_ of: Source.Index) -> Source.Index;
//    
//    public let childIndexs: (_ of: Source.Index) -> Range<Source.Index>;
//    
//    
//    ///Init
//    public init(iob: @escaping (Source._Element, Source._Element) -> Bool, pi: @escaping (Source.Index) -> Source.Index, ci: @escaping (Source.Index) -> Range<Source.Index>) {
//        self.isOrderedBefore = iob;
//        self.parentIndex = pi;
//        self.childIndexs = ci;
//    }
//    
////    ///Return parent index of child index
////    public func parentIndex(of index: Int) -> Int{
////        return (index - 1) >> 1;
////    }
////    
////    ///Return child indexs range of parent index
////    public func childIndexs(of index: Int) -> Range<Int>{
////        let i = index << 1 + 1;
////        return i...i+1;
////    }
//}
//
//
/////MARK: PriorityQueue
//public struct PriorityQueue2<T> {
//    
//    public typealias Source = [T];
//    
//    ///source
//    public fileprivate(set) var source: Source;
//    
//    ///heap builder
//    fileprivate let builder: PQHeapBuilder<Source>
//    
//    ///Init
//    public init(source: Source, isOrderedBefore: @escaping (Source._Element, Source._Element) -> Bool) {
//        self.builder = PQHeapBuilder<Source>(
//            iob: isOrderedBefore,
//            pi: {return ($0 - 1) >> 1},
//            ci: {
//                let i = $0 << 1 + 1
//                return i...i+1;
//            }
//        );
//        self.source = self.builder.building(source);
//    }
//    
//    ///Init
//    public init(isOrderedBefore: @escaping (T, T) -> Bool) {
//        self.init(source: [], isOrderedBefore: isOrderedBefore);
//    }
//}
//
//
//
//
//
//
//
//
//
//
//extension PQHeapBuilder{
//    public typealias T = Source._Element;
//    
//    ///Shift up at index
//    public func shift(up index: Source.Index, of source: inout Source) {
//        let shiftElement = source[index];
//        var shiftIndex = index;
//        let startIndex = source.startIndex;
//        repeat{
//            let pIndex = parentIndex(shiftIndex);
//            
//            guard Collection.distance(from: startIndex, to: pIndex) >= 0
//                && isOrderedBefore(shiftElement, source[pIndex]) else {break;}
//            swap(&source[shiftIndex], &source[pIndex])
//            shiftIndex = pIndex;
//        }while true
//    }
//    
//    ///shift down at index
//    public func shift(down index: Source.Index, of source: inout Source) {
//        var pIndex = index;
//        let endIndex = source.endIndex;
//        repeat{
//            var shiftIndex = pIndex;
//            let cIndexs = childIndexs(pIndex);
//            
//            for cIndex in cIndexs {
//                guard Collection.distance(from: cIndex, to: endIndex) > 0 else {
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
//    public func shift(auto index: Source.Index, of source: inout Source) {
//        let pIndex = parentIndex(index);
//        guard source.distance(from: source.startIndex, to: pIndex) >= 0 else {
//            shift(down: index, of: &source);
//            return;
//        }
//        isOrderedBefore(source[index], source[pIndex]) ?
//            shift(up: index, of: &source) :
//            shift(down: index, of: &source);
//    }
//    
//    ///Return heap array
//    public func building(_ source: Source) -> Source {
//        var source = source;
//        let startIndex = source.startIndex;
//        let endIndex = source.endIndex;
//        guard Collection.distance(from: startIndex, to: endIndex) > 0 else{return source;}
//        var index = parentIndex(Collection.index(endIndex, offsetBy: -1));
//        while Collection.distance(from: startIndex, to: index) >= 0{
//            shift(down: index, of: &source);
//            index = Collection.index(index, offsetBy: -1);
//        }
//        return source;
//    }
//}
//
//
//
//
//
////MARK: extension PriorityQueue public
//extension PriorityQueue2{
//    
//    ///Preview min OR max element
//    public var preview: T? {
//        return source.first;
//    }
//    
//    ///Insert element
//    mutating public func insert(_ element: T) {
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
//    mutating public func replace(_ newValue: T, at index: Int) {
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
//extension PriorityQueue2 where T: Comparable {
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
//extension PriorityQueue2: Collection {
//    public var startIndex: Int{return self.source.startIndex;}
//    public var endIndex: Int{return self.source.endIndex;}
//    public var count: Int{return self.source.count;}
//    public subscript(position: Int) -> T{
//        return self.source[position];
//    }
//}
//
////MARK: PriorityQueue.heap -- Return Heap
//extension PriorityQueue2 {
//    ///Return heap
//    public static func heap(_ source: [T], isOrderedBefore: @escaping (T, T) -> Bool) -> PriorityQueue2{
//        return PriorityQueue2<T>.init(source: source, isOrderedBefore: isOrderedBefore);
//    }
//    
//    ///Return heap
//    public static func heap(_ isOrderedBefore: @escaping (T, T) -> Bool) -> PriorityQueue2{
//        return heap([], isOrderedBefore: isOrderedBefore);
//    }
//}
//
////MARK: PriorityQueue.heap where T: Comparable
//extension PriorityQueue2 where T: Comparable {
//    ///Return minimum heap
//    public static func heap(minimum source: [T]) -> PriorityQueue2{
//        return heap(source){return $0 < $1;}
//    }
//    
//    ///Return maximum heap
//    public static func heap(maximum source: [T]) -> PriorityQueue2{
//        return heap(source){return $0 > $1;}
//    }
//}
