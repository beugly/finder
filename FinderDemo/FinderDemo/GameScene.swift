//
//  GameScene.swift
//  FinderDemo
//
//  Created by 叶贤辉 on 16/1/9.
//  Copyright (c) 2016年 叶贤辉. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "✅⬀✅";
        myLabel.fontSize = 12;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        let v = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)));
        v.fillColor = SKColor.blueColor();
        v.strokeColor = SKColor.redColor();
        v.addChild(myLabel)
        self.addChild(v)
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
