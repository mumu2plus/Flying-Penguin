//
//  Star.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/22.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Star: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize = CGSize(width: 40, height: 38)
    var pulseAnimation = SKAction()
    
    init() {
        let starTexture = textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(pulseAnimation)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createAnimations() {
        // Sacle the star smaller and fade it slightly:
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 0.8),
            SKAction.rotate(byAngle: -0.3, duration: 0.8)
            ])
        
        // Push the star big again, and fade it back in:
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5)
            ])
        
        // Combine the two into a sequence:
        let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
        
    }
    
    func onTap() {
        
    }
    
    
}
