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

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let skView = self.view as! SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.ignoresSiblingOrder = true;
        
        let gs = GameScene();
        gs.size = self.view.bounds.size;
        gs.scaleMode = .aspectFill;
        skView.presentScene(gs);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
