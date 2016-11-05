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
//typealias F = FinderDijkstra<FinderOption2D<FinderSource2D>>;
//typealias F = FinderGreedyBest<FinderOption2D<FinderSource2D>>;
//typealias F = FinderBFS<FinderOption2D<FinderSource2D>>;

private func _pathFinder(markPath: Bool = true, markRecord:Bool = true) {
    let _size = 50;
    let userDiagnal = true;
    var source = FinderSource2D(columns: _size, rows: _size);
    var hinders:[(Int, Int)] = [];
    for i in 0...30{
        hinders.append((i, 3));
    }
    for hinder in hinders {
        source.source[hinder.0, hinder.1] = nil;
    }
    
    let option = FinderOption2D(source: source, useDiagonal: userDiagnal, huristic: .Manhattan);
    let finder = F(option: option);
    
    
    
    
    
    let start = FinderVertex2D(x: 0, y: 0);
    let goal = FinderVertex2D(x: 10, y: 30);
    
    var record: [F.Vertex: F.Element]?;
    
    guard let result = (finder.find(from: start, to: goal){record = $0.record}) else {
        return;
    }
    
    if !markRecord{
        return;
    }
    
    var printMap = Array2D(columns: _size, rows: _size, initialValue: "✅");
    if let record = record, markRecord{
        for re in record{
            let e = re.value;
            if let p = e.parent {
                let v = e.vertex;
                let arrow = TestArrow.getArrow(v.x, y1: v.y, x2: p.x, y2: p.y).description;
                printMap[v.x, v.y] = arrow;
            }
        }
    }

    for hinder in hinders{
        printMap[hinder.0, hinder.1] = "❌";
    }
    
    if markPath{
        let pathIcon = "📍";
        for r in result {
            printMap[r.x, r.y] = pathIcon;
        }
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
