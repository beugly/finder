//
//  Collection2D.swfit
//  X_Framework
//
//  Created by xifanGame on 15/9/16.
//  Copyright (c) 2015年 yeah. All rights reserved.
//

import Foundation

//MARK: Array2D
public struct Array2D<T> {
    
    ///Columns and rows
    public let columns, rows: Int;
    
    ///Source array
    public fileprivate(set) var source: [T];
    
    ///Init
    public init(columns: Int, rows: Int, repeatValue: T) {
        self.columns = columns;
        self.rows = rows;
        self.source = .init(repeating: repeatValue, count: columns * rows);
    }
}

//MARK: extension Array2D
extension Array2D {
    ///Subscript
    public subscript(column: Int, row: Int) -> T {
        set{
            self.source[position2Index(column, row: row)] = newValue;
        }
        get{
            return self.source[position2Index(column, row: row)];
        }
    }
    
    ///Position to Index
    fileprivate func position2Index(_ column: Int, row: Int) -> Int {
        return row * columns + column
    }
}

//MARK: extension Array2D: CollectionType
extension Array2D: Collection {
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return i + 1;
    }

    public var startIndex: Int {return self.source.startIndex;}
    public var endIndex: Int {return self.source.endIndex;}
    public var count: Int {return self.source.count;}
    public subscript(index: Int) -> T {
        return self.source[index];
    }
}

//MARK: extension Array2D: CustomStringConvertible
extension Array2D: CustomStringConvertible {
    public var description: String{
        return "columns: \(columns), rows: \(rows) \n\(self.source.description)";
    }
}

//MARK: extension Array2D: CustomDebugStringConvertible
extension Array2D: CustomDebugStringConvertible {
    public var debugDescription:String{
        var desc:String = "";
        for r in 0..<self.rows
        {
            for c in 0..<self.columns
            {
                desc += "\(self[c, r]) ";
            }
            desc += "\n";
        }
        return desc;
    }
}
