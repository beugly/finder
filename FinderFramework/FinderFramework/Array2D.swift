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
    public private(set) var source: [T];
    
    ///Init
    public init(columns: Int, rows: Int, repeatValue: T) {
        self.columns = columns;
        self.rows = rows;
        self.source = .init(count: columns * rows, repeatedValue: repeatValue);
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
    private func position2Index(column: Int, row: Int) -> Int {
        return row * columns + column
    }
}

//MARK: extension Array2D: CollectionType
extension Array2D: CollectionType {
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