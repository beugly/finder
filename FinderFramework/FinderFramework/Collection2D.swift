//
//  Collection2D.swfit
//  X_Framework
//
//  Created by xifanGame on 15/9/16.
//  Copyright (c) 2015年 yeah. All rights reserved.
//

import Foundation

//MARK: collection 2d type
public protocol Collection2DType: CollectionType
{
    //columns
    var columns: Int{get}
    
    //rows
    var rows: Int{get}
    
    //subscript
    subscript(column:Int, row:Int) -> Self.Generator.Element? {get set}
}
//MARK: extension public
public extension Collection2DType
{
    //column, row is valid
    func isValid(column:Int, _ row:Int) -> Bool
    {
        return column >= 0 && column < columns && row >= 0 && row < rows;
    }
}
//MARK: extension internal
extension Collection2DType
{
    //return index in collection at column and row
    func indexAt(column:Int, _ row:Int) -> Int
    {
        return column + columns * row
    }
    
    //return position
    func positionAt(index: Int) -> (column:Int, row:Int)
    {
        let column = index % self.columns;
        let row:Int = index / self.columns;
        return (column: column, row: row);
    }
}
//MARK: extension CollectionType
extension Collection2DType where Self.Index == Int
{
    //return element position
    @warn_unused_result
    public func positionOf(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows ->(column:Int, row:Int)?
    {
        guard let index = try self.indexOf(predicate) else {return nil;}
        let temp = positionAt(index);
        if isValid(temp.column, temp.row)
        {
            return temp;
        }
        return nil;
    }
}
extension Collection2DType where Self.Index == Int, Self.Generator.Element: Equatable
{
    //if exist, return position else return nil
    @warn_unused_result
    public func positionOf(element: Self.Generator.Element) -> (column:Int, row:Int)?
    {
        guard let index = self.indexOf(element) else {return nil;}
        let temp = positionAt(index);
        if isValid(temp.column, temp.row)
        {
            return temp;
        }
        return nil;
    }
}
//MARK: extension CustomStringConvertible
extension Collection2DType where Self: CustomDebugStringConvertible
{
    public var debugDescription:String{
        var text:String = "";
        for r in 0..<self.rows
        {
            for c in 0..<self.columns
            {
                guard let e = self[c, r] else{
                    text += "nil";
                    continue;
                }
                text += "\(e) ";
            }
            text += "\n";
        }
        return text;
    }
}

//MARK: struct array 2d
public struct Array2D<Element> {
    //source
    private var source: [Element?];
    private(set) public var columns, rows:Int;
    
    
    /// Construct a Array2D of `count` elements, each initialized to
    /// `repeatedValue`.
    public init(columns:Int, rows:Int, repeatValue: Element?)
    {
        self.columns = columns;
        self.rows = rows;
        let c = columns * rows
        self.source = Array<Element?>(count: c, repeatedValue: repeatValue);
    }
    
    public init(columns:Int, rows:Int, values: [Element?]? = nil)
    {
        self.columns = columns;
        self.rows = rows;
        self.source = values ?? [];
    }
    
    public init(columns:Int, rows:Int)
    {
        self.init(columns: columns, rows: rows, repeatValue: .None);
    }
}
//MARK: extension Array2DType
extension Array2D: Collection2DType
{
    //subscript
    public subscript(column:Int, row:Int) -> Element? {
        set{
            guard isValid(column, row) else {return;}
            let index = self.indexAt(column, row)
            self.source[index] = newValue;
        }
        get{
            guard isValid(column, row) else {return .None;}
            let index = self.indexAt(column, row);
            return self.source[index];
        }
    }
    
    /// collection
    public var startIndex: Int {return 0}
    public var endIndex: Int {return self.source.count;}
    public subscript(i: Int) -> Element{return self.source[i]!}
}
extension Array2D: CustomDebugStringConvertible{}