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

    private var _finderMap: FinderMapProtocol? = nil;
    private var opt: FinderSetting = .Start;
    

    
    
    @IBAction func startFind(_ sender: AnyObject) {
        (_finderMap as? FinderMap)?.find();
        
        
    }
    
    @IBAction func setMap(_ sender: UISegmentedControl) {
        opt = FinderSetting(value: sender.selectedSegmentIndex);
    }
    
    
    @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
        _finderMap?.zoomTo(sender.scale);
    }
    
    
    private var isDragging: Bool = false;
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            isDragging = false;
            return;
        }
        
        if let pos = touches.first?.location(in: self.view) {
            //set position
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDragging {
            isDragging = false;
            return;
        }
        
        if let pos = touches.first?.location(in: self.view) {
            //set position
            switch opt {
            case .Start:
                _finderMap?.setStarts(at: pos)
            case .Goals:
                _finderMap?.setGoal(at: pos);
            case .Terrain:
                _finderMap?.setTerrain(at: pos);
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "FinderScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                _finderMap = (scene as? FinderGS)?.finderMap;
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
