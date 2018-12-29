//
//  Coin.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/22.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    
    var initialSize: CGSize = CGSize(width: 26, height: 26)
    
    var value = 1
    
    let coinSound =
        SKAction.playSoundFileNamed("Sound/Coin.aif", waitForCompletion: false)
    
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onTap() {
        
    }
    
    func collect() {
        // Prevent further contact:
        self.physicsBody?.categoryBitMask = 0
        // Fade out, moveup, and scale up the coin:
        let collectAnimation = SKAction.group([
            SKAction.fadeAlpha(to: 0, duration: 0.2),
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)
            ])
        let resetAfterCollected = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        // Combine the actions into a sequence:
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
            ])
        // Run the collect animation:
        self.run(collectSequence)
        
        // Play the coin sound:
        self.run(coinSound)
    }
    
    
}
