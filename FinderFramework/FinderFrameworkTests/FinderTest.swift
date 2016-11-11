//
//  FinderTest.swift
//  X_Framework
//
//  Created by xifanGame on 15/9/17.
//  Copyright © 2015年 yeah. All rights reserved.
//

import UIKit
@testable import FinderFramework;






public func pathFinderTest(_ flag: Bool) {
    _pathFinder(!flag, !flag);
}


typealias F = FinderAstar<FinderGrid2DOption>;
//typealias F = FinderDijkstra<FinderGrid2DOption>;
//typealias F = FinderGreedyBest<FinderGrid2DOption>;
//typealias F = FinderBFS<FinderGrid2DOption>;
//typealias F = FinderJPS<FinderGrid2DOption>;


private func _pathFinder(_ markPath: Bool = false, _ markRecord:Bool = false) {
    let _size = 80;
    var source = FinderGrid2D(columns: _size, rows: _size, initialValue: 1);
    var obstacles:[(Int, Int)] = [];
    for i in 0...30{
        obstacles.append((i, 30));
    }
    for o in obstacles {
        source.setPlacementWeight(nil, at: o.0, row: o.1);
    }
    
    let option = FinderGrid2DOption(source: source, huristic: .Manhattan, expandModel: .Diagonal);
    let finder = F(option: option);
    
    
    
    
    
    let start = FinderVertex2D(x: 0, y: 0);
    let goal = FinderVertex2D(x: 0, y: _size - 1);
    
    var record: [FinderVertex2D: FinderElement2D]?;
    
    let result = (finder.find(target: goal, from: start){record = $0.record});
    if result.count == 0{
        return;
    }
    
    if !markRecord{
        return;
    }
    
    var printMap = FinderArray2D(columns: _size, rows: _size, initialValue: "✅");
    if let record = record {
        for re in record{
            let e = re.value;
            if let p = e.parent {
                let v = e.vertex;
                let arrow = TestArrow.getArrow(v.x, y1: v.y, x2: p.x, y2: p.y).description;
                printMap[v.x, v.y] = arrow;
            }
        }
    }

    for o in obstacles{
        printMap[o.0, o.1] = "❌";
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



private func _printMap(map: FinderArray2D<String>) {
    for r in 0..<map.rows {
        var str = "";
        for c in 0..<map.columns {
            let v = map[c, r]
            str += v;
        }
        print(str);
    }
}
