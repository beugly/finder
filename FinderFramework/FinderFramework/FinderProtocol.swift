//
//  FinderProtocol.swift
//  FinderFramework
//
//  Created by 叶贤辉 on 16/4/23.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation

//MARK: == FinderProtocol ==
public protocol FinderProtocol: GeneratorType {
    ///Point Type
    associatedtype Point;
    
    ///Return neighbors of Element
    func neighborsOf(element: Element) -> [Point]
    
    ///Expanding point around element
    mutating func expanding(point: Point, around: Element?)
    
    ///Searching
    mutating func search(element: Element) -> Bool
}
extension FinderProtocol {
    
    ///Find
    final mutating func find(origin: Point) {
        self.expanding(origin, around: .None);
        
        repeat {
            guard let element = self.next()
                where self.search(element) == false
                else {
                    return;
            }
            neighborsOf(element).forEach {
                let p = $0;
                self.expanding(p, around: element);
            }
        }while true;
    }
}


