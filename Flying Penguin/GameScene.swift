//
//  GameScene.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/18.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    let motionManager = CMMotionManager()

    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:0.95, alpha: 1.0)
        self.camera = cam
        
        
        
        let bee2 = Bee()
        bee2.position = CGPoint(x: 325, y: 325)
        self.addChild(bee2)
        
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y: 325)
        self.addChild(bee3)
        
        // Position the ground based on the screen size.
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        player.position = CGPoint(x: 150, y: 250)
        self.addChild(player)
        
        self.motionManager.startAccelerometerUpdates()
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = player.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
        
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            var movement = CGVector()
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                forceAmount = 20000
            case .landscapeRight:
                forceAmount = -20000
            default:
                forceAmount = 0
            }
            
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            } else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
            
            player.physicsBody?.applyForce(movement)
        }
    }
}
