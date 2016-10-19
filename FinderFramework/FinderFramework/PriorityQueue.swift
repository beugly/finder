//
//  PriorityQueue.swift
//  X_Framework
//
//  Created by xifanGame on 15/10/28.
//  Copyright © 2015年 yeah. All rights reserved.
//

import Foundation


//MARK: PriorityQueueProtocol
public protocol PriorityQueueProtocol {
    /// The type of element traversed by the priority queue.
    associatedtype Element;
    
    /**
        Inserts the given element into the priority queue unconditionally.
        - Parameter newElement: An element to insert into the priority queue
     */
    mutating func enqueue(_ newElement: Element)
    
    /**
        Pop the optimal element and remove it
        - Returns: the optimal element that was removed, or 'nil' if the priority queue is empty.
     */
    mutating func dequeue() -> Element?
    
    /**
        Updates the element stored in the priority queue at the given index
        - Parameters: 
            - element: the new element
            - index: the index to found the old element
        - Returns: the old element at index, or 'nil' if it is not exist at index
     */
    @discardableResult
    mutating func update(_ element: Element, at index: Int) -> Element?
    
    /**
     Remove element at index
     - Parameter index: the given index
     - Returns: element at the given index
     */
    @discardableResult
    mutating func remove(at index: Int) -> Element?
}
extension PriorityQueueProtocol {
    public mutating func dequeue() -> Element? {
        return remove(at: 0);
    }
}

//MARK: PriorityQueue
/// minimum - isOrderedBefore: $0 < $1
/// maximum - isOrderedBefore: $0 > $1
/// forkCount - fork count, heap: forkCount = 2
public struct PriorityQueue<Element> {
    /// A type that can represent the data source
    public typealias Source = [Element];
    
    /// source
    public fileprivate(set) var elements: Source = [];
    
    /// is order before
    fileprivate let _isOrderedBefore: (Element, Element) -> Bool;
    
    /// fork count
    fileprivate let _forkCount: Int;
    
    /// Init
    public init(isOrderedBefore: @escaping (Element, Element) -> Bool, forkCount: Int){
        self._isOrderedBefore = isOrderedBefore;
        self._forkCount = forkCount;
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
extension PriorityQueue: PriorityQueueProtocol{
    mutating public func enqueue(_ newElement: Element) {
        elements.append(newElement);
        shift(up: elements.count - 1);
    }
    
    @discardableResult
    mutating public func update(_ element: Element, at index: Int) -> Element? {
        guard index < elements.count else {
            return nil;
        }
        let old = elements[index];
        elements[index] = element;
        shift(auto: index);
        return old;
    }
    
    @discardableResult
    mutating public func remove(at index: Int) -> Element? {
        let c = elements.count;
        guard index < c else {
            return nil;
        }
        
        let _endIndex = c - 1;
        if index == _endIndex {
            return elements.removeLast();
        }
        else  {
            swap(&elements[index], &elements[_endIndex]);
            let e = elements.removeLast();
            shift(up: index);
            shift(down: index);
            return e;
        }
    }
}
extension PriorityQueue {
    /**
     - Returns: Optimal element
     */
    public var peek: Element? {
        return elements.first;
    }
    
    /// Build priority queue
    /// - Parameters:
    ///     - newSource: data source
    mutating public func build(_ newElements: Source) {
        self.elements = newElements;
        guard !elements.isEmpty else {
            return;
        }
        
        let eIndex = elements.count - 1;
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
        let shiftElement = elements[index];
        var shiftIndex = index;
        
        while shiftIndex > 0{
            let pIndex = parentIndexOf(shiftIndex);
            guard _isOrderedBefore(shiftElement, elements[pIndex]) else {
                break;
            }
            swap(&elements[shiftIndex], &elements[pIndex])
            shiftIndex = pIndex;
        }
    }
    
    ///shift down at index
    mutating func shift(down index: Int) {
        let eIndex = elements.count;
        var pIndex = index;
        repeat{
            var shiftIndex = pIndex;
            var cIndex = childIndexOf(shiftIndex);
            let temp = cIndex + _forkCount;
            let ceIndex = temp > eIndex ? eIndex : temp;
            
            while ceIndex > cIndex{
                if _isOrderedBefore(elements[cIndex], elements[shiftIndex]) {
                    shiftIndex = cIndex;
                }
                cIndex += 1;
            }
            
            guard shiftIndex != pIndex else {
                break;
            }
            swap(&elements[pIndex], &elements[shiftIndex])
            pIndex = shiftIndex;
        }while true;
    }
    
    ///Auto shift element at index
    mutating func shift(auto index: Int) {
        guard index >= 0 else {
            return;
        }
        
        let pIndex = parentIndexOf(index);
        _isOrderedBefore(elements[index], elements[pIndex]) ? shift(up: index) : shift(down: index);
    }
    
    /// Return parent index
    /// - Parameter index: child index
    /// - Returns: parent index of child index
    func parentIndexOf(_ index: Int) -> Int{
        return (index - 1) / _forkCount;
    }
    
    /// Return minimum child index
    /// - Parameter index: parent index
    /// - Returns: minimum child index of parent index
    func childIndexOf(_ index: Int) -> Int {
        return index * _forkCount + 1;
    }
}
//MARK: extension PriorityQueue: CollectionType
extension PriorityQueue: Collection {
    public var count: Int{return elements.count;}
    public var startIndex: Int{return elements.startIndex;}
    public var endIndex: Int{return elements.endIndex;}
    public subscript(index: Int) -> Element {return elements[index];}
    public func index(after i: Int) -> Int {return i + 1;}
}
