//
//  Crate.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/29.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 40, height: 40)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: UIColor.clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        // Only collide with the ground and other crates
        self.physicsBody?.collisionBitMask =
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.crate.rawValue
        self.physicsBody?.categoryBitMask =
            PhysicsCategory.crate.rawValue
        
        self.texture = textureAtlas.textureNamed("crate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // A function to create a crate that gives health:
    func turnToHeartCrate() {
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    // A function for exploding crates!
    func explode(gameScene: GameScene) {
        // Do not do anything if already exploded:
        if exploded {return}
        exploded = true
        
        // Place a crate explosion at this location:
        gameScene.particlePool.placeEmitter(node: self, emitterType: "crate")
        // Fade out the crate sprite
        self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
        
        if (givesHeart) {
            // If this is a heart crate, award a health point:
            let newHealth = gameScene.player.health + 1
            let maxHealth = gameScene.player.maxHealth
            gameScene.player.health = newHealth > maxHealth ? maxHealth : newHealth
            gameScene.hud.setHealthDisplay(newHealth: gameScene.player.health)
            // Place a heart explosion at this location:
            gameScene.particlePool.placeEmitter(node: self, emitterType: "heart")
        } else {
            // Otherwise, reward the player with coins:
            gameScene.coinsCollected += 1
            gameScene.hud.setCoinCountDisplay(newCoinCount: gameScene.coinsCollected)
        }
        
        // Prevent additional contact:
        self.physicsBody?.categoryBitMask = 0
        
        // TODO: We will add more here in a bit
    }
    
    // A function to reset the crate for re-use
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
    }
    
    // Conform to the necessary protocols:
    func onTap() {
        
    }
    
    
}
