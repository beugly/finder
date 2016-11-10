//
//  FinderMap.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/26.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation
import SpriteKit;
import FinderFramework;


class FinderMap: SKNode {
    
    ///ground
    var ground: SKTileMapNode? = nil;
    
    fileprivate var start: FinderVertex2D? = nil;
    fileprivate var goal: FinderVertex2D? = nil;
    
    fileprivate let resultNode = SKNode();
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        guard let temp = self.childNode(withName: "ground") as? SKTileMapNode else {
            fatalError("init(coder:) 'ground' tile map not found");
        }
        self.ground = temp;
        self.addChild(resultNode);
        isUserInteractionEnabled = true;
        
        self.start = getVertex(by: "start");
        self.goal = getVertex(by: "goal");
        print(start, goal);
    }
    
    private func getVertex(by name: String) -> FinderVertex2D? {
        guard let node = self.childNode(withName: name) else {
            return nil;
        }
        
        let pos = self.convert(node.position, to: ground!);
        let x = self.ground?.tileColumnIndex(fromPosition: pos) ?? 0;
        let y = self.ground?.tileRowIndex(fromPosition: pos) ?? 0;
        return FinderVertex2D(x: x, y: y);
    }
}
extension FinderMap {
    func find() {
        let opt = FinderOption2D(source: self, expandModel: .DiagonalIfAtMostOneObstacles, huristic: .Manhattan);
        let f = FinderAstar(option: opt);
        var dic: [FinderVertex2D: FinderElement<FinderVertex2D>] = [:];
        let result = f.find(target: goal!, from: start!) {
            dic = $0.record;
        };
        if result.isEmpty {
            return;
        }
        showResult(path: result, record: dic);
    }
}

extension FinderMap {
    ///terrrain
    enum Terrain {
        case Land, Water
        init(name: String) {
            switch name {
            case "Water":
                self = .Water;
            default:
                self = .Land;
            }
        }
        
        var cost: CGFloat {
            switch self {
            case .Water:
                return 2;
            default:
                return 1;
            }
        }
    }
    
    //to next group at column, row
    func toNextGroup(atColumn c: Int, row r: Int) {
        guard let _ground = ground else {
            return;
        }
        var newGroup: SKTileGroup?;
        if let g = _ground.tileGroup(atColumn: c, row: r) {
            let groups = _ground.tileSet.tileGroups;
            if let index = groups.index(of: g) {
                newGroup = (index == groups.count - 1 ? nil : groups[index + 1]);
            }
        }
        else {
            newGroup = _ground.tileSet.tileGroups[0];
        }
        _ground.setTileGroup(newGroup, forColumn: c, row: r);
        
//        print(newGroup?.rules.first?.tileDefinitions.first?.placementWeight)
        print(newGroup?.rules.first?.adjacency)
    }
}

extension FinderMap: FinderGrid2DProtocol {
    func placementWeight(at column: Int, row: Int) -> CGFloat? {
        guard let g = ground?.tileGroup(atColumn: column, row: row) else {
            return nil;
        }
        var terrain: Terrain;
        if let n = g.name {
            terrain = .init(name: n);
        }
        else {
            terrain = .Land;
        }
        return terrain.cost;
    }
}
extension FinderMap: FinderMapProtocol {
    
    func setStarts(at positions: CGPoint...) {
        print("setStarts")
    }
    
    func setGoal(at position: CGPoint...) {
        print("setGoal")
    }
    
    func setTerrain(at position: CGPoint) {
        guard let cr = getColumnAndRow(at: position) else {
            return;
        }
        toNextGroup(atColumn: cr.column, row: cr.row);
    }
    
    private func getColumnAndRow(at position: CGPoint) -> (column: Int, row: Int)? {
        guard let _ground = ground else {
            return nil;
        }
        let c = _ground.tileColumnIndex(fromPosition: position);
        let r = _ground.tileRowIndex(fromPosition: position);
        return (c, r);
    }
    
    func showResult(path: [FinderVertex2D], record: [FinderVertex2D : FinderElement2D]) {
        self.resultNode.removeAllChildren();
        var result = path;
        for v in record {
            var ispath: Bool = false;
            if let i = result.index(of: v.key) {
                result.remove(at: i);
                ispath = true;
            }
            let item = FinderResultItem.create(data: v.value, isPath: ispath);
            let pos = ground!.centerOfTile(atColumn: v.key.x, row: v.key.y);
            item.position = pos;
            resultNode.addChild(item);
        }
        
    }
}




