//
//  GameViewController.swift
//  FinderDemo
//
//  Created by 叶贤辉 on 16/1/9.
//  Copyright (c) 2016年 叶贤辉. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    weak var gameScene: GameScene!;
    weak var finderMap: FinderMap!;
    
    @IBOutlet weak var isMultiGoals: UISwitch!;
    @IBOutlet weak var allowDiagoanl: UISwitch!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let skView = self.view as! SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.ignoresSiblingOrder = true;
        
        let gs = GameScene();
        gs.size = self.view.bounds.size;
        gs.scaleMode = .AspectFill;
        skView.presentScene(gs);
        self.gameScene = gs;
        
        let mp = FinderMap();
        mp.findCallBack = self.find;
        mp.position = CGPoint(x: nodeSize, y: nodeSize);
        gs.addChild(mp);
        self.finderMap = mp;
        
        
        findModelChanged();
        goalsChanged();
    }
    
    @IBAction func findModelChanged(sender: UISwitch? = .None) {
        self.finderMap.model = !allowDiagoanl.on ? .Straight : .Diagonal;
        print(self.finderMap.model);
    }
    
    @IBAction func goalsChanged(sender: AnyObject? = .None) {
        self.finderMap.setGoalsType(!isMultiGoals.on);
        print(self.finderMap.isMutiGoal);
    }
    
    private func find(){
        print("start find path")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
