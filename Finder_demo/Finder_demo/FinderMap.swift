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


var finderSetting: FinderSetting = .Start;

class FinderMap: FinderMapAbstract {
    
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
    
    override func touchUp(atPoint pos: CGPoint) {
        if !isDragging {
            switch finderSetting {
            case .Terrain:
                toNextGroup(atPosition: pos);
            case .Start:
                print("start")
            case .Goals:
                print("goal")
            }
        }
        super.touchUp(atPoint: pos);
    }
    
    ///cost of
    override func costOf(_ group: SKTileGroup) -> Int {
        var terrain: Terrain;
        if let n = group.name {
            terrain = .init(name: n);
        }
        else {
            terrain = .Land;
        }
        return terrain.cost;
    }
}
extension FinderMap {
    func find() {
        let opt = FinderOption2D(source: self, useDiagonal: true);
        let f = FinderAstar(option: opt);
        var dic: [FinderVertex2D: FinderElement<FinderVertex2D>] = [:];
        if let result = (f.find(from: start!, to: goal!) {
            dic = $0.record;
        }) {
            showResult(result: result, record: dic);
        }
        
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
        
        var cost: Int {
            switch self {
            case .Water:
                return 2;
            default:
                return 1;
            }
        }
    }
}
extension FinderMap {
    func showResult(result: [FinderVertex2D], record: [FinderVertex2D: FinderElement<FinderVertex2D>]) {
        self.resultNode.removeAllChildren();
        var result = result;
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

enum FinderSetting {
    case Start, Goals, Terrain
    init(value: Int){
        switch value {
        case 0:
            self = .Start;
        case 1:
            self = .Goals;
        default:
            self = .Terrain;
        }
    }
}
