//
//  FinderTest.swift
//  X_Framework
//
//  Created by xifanGame on 15/9/17.
//  Copyright © 2015年 yeah. All rights reserved.
//

import UIKit
@testable import FinderFramework;






public func pathFinderTest() {
    _pathFinder();
}


typealias F = FinderAstar<FinderOption2D<FinderSource2D>>;

private func _pathFinder(markPath: Bool = true) {
//    let markRecord = true;
    let _size = 50;
    let userDiagnal = true;
    var source = FinderSource2D(columns: _size, rows: _size);
    let hinders:[(Int, Int)] = [(3, 3), (2, 3), (1, 3), (0, 3), (4, 3), (5, 3), (6, 3)];
    for hinder in hinders {
        source.source[hinder.0, hinder.1] = nil;
    }
    
    let option = F.Option(source: source, useDiagonal: userDiagnal, huristic: .Manhattan);
    let finder = F(option: option);
    
    
    
    
    
    let start = FinderVertex2D(x: _size >> 1, y: _size >> 1);
    let goal = FinderVertex2D(x: 0, y: 0);
    
    guard let result = finder.find(from: start, to: goal) else {
        return;
    }
    
    if !markPath {
        return;
    }
    
    var printMap = Array2D(columns: _size, rows: _size, initialValue: "✅");
//    if markVisited{
//        let visited = getVisited()
//        visited.forEach{
//            let point = $0.point;
//            guard let parentpoint = $0.backward else {return;}
//            let arrow = TestArrow.getArrow(point.x, y1: point.y, x2: parentpoint.x, y2: parentpoint.y).description;
//            printMap[point.x , point.y] = arrow;
//        }
//    }

    for hinder in hinders{
        printMap[hinder.0, hinder.1] = "❌";
    }
    
    let pathIcon = "📍";
    for r in result {
        printMap[r.x, r.y] = pathIcon;
    }
    
    printMap[start.x, start.y] = "🚹";
    printMap[goal.x, goal.y] = "🚺";
    
    
    _printMap(map: printMap);
}



private func _printMap(map: Array2D<String>) {
    for r in 0..<map.rows {
        var str = "";
        for c in 0..<map.columns {
            let v = map[c, r]
            str += v;
        }
        print(str);
    }
}





struct FinderSource2D {
    var source: Array2D<Int?>;
    init(columns: Int, rows: Int){
        self.source = Array2D(columns: columns, rows: rows, initialValue: 1);
    }
    func costOf(x: Int, y: Int) -> Int? {
        guard x > -1 && x < source.columns && y > -1 && y < source.rows else {
            return nil;
        }
        return source[x, y];
    }
}
extension FinderSource2D: FinderDataSource2D{}
