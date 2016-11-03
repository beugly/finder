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

    
    
    
    private var _mapNode: SKNode? = nil;
    private var opt: FinderSetting = .Start;
    

    
    
    @IBAction func startFind(_ sender: AnyObject) {
        (_mapNode as? FinderMap)?.find();
        
        
    }
    
    @IBAction func setMap(_ sender: UISegmentedControl) {
        opt = FinderSetting(value: sender.selectedSegmentIndex);
    }
    
    
    private var _lastPitchScale: CGFloat = 1.0;
    @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            sender.scale = _lastPitchScale;
            return;
        }
        _lastPitchScale = sender.scale;
        _mapNode?.setScale(_lastPitchScale);
    }
    
    
    private var isDragging: Bool = false;
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            isDragging = false;
            return;
        }
        
        if !isDragging {
            isDragging = true;
        }
        
        if let pos = touches.first?.location(in: view),
            let prePos = touches.first?.previousLocation(in: view)
        {
            let offsetx = pos.x - prePos.x;
            let offsety = pos.y - prePos.y;
            _mapNode?.position.x += offsetx;
            _mapNode?.position.y -= offsety;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDragging {
            isDragging = false;
            return;
        }
        
        guard let _map = _mapNode, let _fmap = _map as? FinderMapProtocol else {
            return;
        }
        
        if let pos = touches.first?.location(in: _map) {
            switch opt {
            case .Start:
                _fmap.setStarts(at: pos)
            case .Goals:
                _fmap.setGoal(at: pos);
            case .Terrain:
                _fmap.setTerrain(at: pos);
            }
        }
    }
    
    
    
    @IBOutlet weak var optionBar: UIView!
    @IBAction func hidderBar(_ sender: UIButton) {
        let _isHidden = !optionBar.isHidden;
        optionBar.isHidden = _isHidden;
    }
    
    
    @IBAction func helpHandle(_ sender: AnyObject) {
        helpInfo.isHidden = !helpInfo.isHidden;
    }
    @IBOutlet weak var helpInfo: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "FinderScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                _mapNode = (scene as? FinderGS)?.finderMap as? SKNode;
            }
            
            helpInfo.isHidden = true;
            
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
