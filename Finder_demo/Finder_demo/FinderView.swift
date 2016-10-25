//
//  FinderContainer.swift
//  Finder_demo
//
//  Created by xifangame on 16/10/24.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import Foundation;
import SpriteKit;
import FinderFramework;


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

var finderSetting: FinderSetting = .Start;


///FinderTerrain
enum FinderTerrain {
    case Glass, Water
}

extension FinderMap {
    func find() {
        
    }
}


///finder map
class FinderMap: FinderMapBase {
    
    ///finder map
    fileprivate var _map: SKTileMapNode!;
    
    ///map data
    fileprivate var _mapData: Array2D<FinderTerrain?>!;
    
    ///tile groups
    fileprivate var _tileGroups: [SKTileGroup] = []
    
    fileprivate var start: FinderVertex2D = FinderVertex2D(x: 0, y: 0);
    fileprivate var goals: [FinderVertex2D] = [FinderVertex2D(x: 10, y: 10)];
    
    init(mapData: Array2D<FinderTerrain?>, size: Int = 64) {
        super.init();
        guard let tileSet = SKTileSet(named: "Finder Ground") else {
            fatalError("init(columns:rows:size) 'Finder Ground' tile set not found");
        }
        
        _tileGroups = tileSet.tileGroups;
        self._map = SKTileMapNode(tileSet: tileSet, columns: mapData.columns, rows: mapData.rows,
                                  tileSize: CGSize(width: size, height: size));
        setMapBy(mapData: mapData);
        isUserInteractionEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        guard let temp = self.childNode(withName: "map") as? SKTileMapNode else {
            fatalError("init(coder:) 'map' tile map not found");
        }
        self._map = temp;
        _tileGroups = _map.tileSet.tileGroups;
        parseMapData();
        isUserInteractionEnabled = true;
    }
    
    override func changeTerrain(at pos: CGPoint) {
        switch finderSetting {
        case .Terrain:
            changeTile(at: pos);
        case .Start:
            print("start")
        case .Goals:
            print("goal")
        }
    }
}
extension FinderMap: FinderDataSource2D {
    ///return cost
    func costOf(x: Int, y: Int) -> Int? {
        guard let t = _mapData[x, y] else {
            return nil;
        }
        
        return t == .Glass ? 1 : 2;
    }
}
extension FinderMap {
    
    func changeTile(at mapPos: CGPoint) {
        let pos = self.convert(mapPos, to: _map);
        let c = _map.tileColumnIndex(fromPosition: pos);
        let r = _map.tileRowIndex(fromPosition: pos);
        var terrain = _mapData[c, r];
        if terrain == nil{
            terrain = .Glass;
        }
        else if terrain == .Glass{
            terrain = .Water;
        }
        else {
            terrain = nil;
        }
        _mapData[c, r] = terrain;
        let group = getTileGroup(of: terrain);
        _map.setTileGroup(group, forColumn: c, row: r);

    }
    
    
    
    func setMapBy(mapData: Array2D<FinderTerrain?>) {
        self._mapData = mapData;
        for r in 0..<_map.numberOfRows{
            for c in 0..<_map.numberOfColumns{
                let group = getTileGroup(of: _mapData[c, r]);
                _map.setTileGroup(group, forColumn: c, row: r);
            }
        }
    }
    
    func parseMapData() {
        self._mapData = Array2D<FinderTerrain?>(columns: _map.numberOfColumns, rows: _map.numberOfRows, initialValue: nil);
        for r in 0..<_map.numberOfRows{
            for c in 0..<_map.numberOfColumns{
                let groupName = _map.tileGroup(atColumn: c, row: r)?.name;
                let terrain = getTerrain(of: groupName);
                _mapData[c, r] = terrain;
            }
        }
    }
    
    private func getTileGroup(of terrain: FinderTerrain?) -> SKTileGroup? {
        guard let t = terrain else {
            return nil;
        }
        switch t {
        case .Glass:
            return _tileGroups[0];
        default:
            return _tileGroups[1];
        }
    }
    
    private func getTerrain(of groupName: String?) -> FinderTerrain? {
        guard let n = groupName else {
            return nil;
        }
        return n == "Glass" ? .Glass : .Water;
    }
}



