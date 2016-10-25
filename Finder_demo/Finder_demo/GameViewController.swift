//
//  GameViewController.swift
//  Finder_demo
//
//  Created by 叶贤辉 on 2016/10/21.
//  Copyright © 2016年 叶贤辉. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    private var finderMap: SKNode?;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "FinderScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                finderMap = (scene as? FinderGS)?.finderMap;
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func startFind(_ sender: AnyObject) {
        (finderMap as? FinderMap)?.find();
    }
    
    @IBAction func setMap(_ sender: UISegmentedControl) {
        finderSetting = FinderSetting(value: sender.selectedSegmentIndex);
    }
    
    @IBAction func expanding(_ sender: UISlider) {
        finderMap?.setScale(CGFloat(sender.value));
    }
}
