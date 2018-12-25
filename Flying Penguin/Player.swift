//
//  Player.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/19.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Pierre")
    var initialSize = CGSize(width: 64, height: 64)
    
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    var flapping = false
    let maxFlappingForce: CGFloat = 57000
    let maxHeight: CGFloat = 1000
    
    // The player will be able to take 3 hits before game over:
    var health: Int = 3
    // Keep track of when the player is invulnerable:
    var invulnerable = false
    // Keep track of when the player is newly damaged:
    var damaged = false
    // We will create animations to run when the player takes
    // damage or dies, Add these properties to store them:
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // We want to stop forward velocity if the player dies,
    // so we will now store forward velocity as a property:
    var forwardVelocity: CGFloat = 200
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        createAnimations()
        self.run(soarAnimation, withKey: "soarAnimation")
        
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        self.physicsBody?.linearDamping = 0.9
        self.physicsBody?.mass = 30
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask =
            PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    }
    
    func update() {
        if self.flapping {
            var forceToApply = maxFlappingForce
            if position.y > 600 {
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
        
        // Set a constant velocity to the right:
        self.physicsBody?.velocity.dx = self.forwardVelocity
    }
    
    func createAnimations() {
        let rotateUpAction =
            SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
            ])
        
        let soarFrames: [SKTexture] =
            [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onTap() {
        print(" tapping on penguin")
    }
    
    // Begin the flap animation, set flapping to true:
    func startFlapping() {
        if self.health <= 0 {return}
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stop the flap animation, set flapping to false:
    func stopFlapping() {
        if self.health <= 0 {return}
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // Make sure the player is fully visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run the die animation:
        self.run(self.dieAnimation)
        // Prevent any further upward movement:
        self.flapping = false
        // Stop forward movement:
        self.forwardVelocity = 0
    }
    
    func takeDamage() {
        // If invulnerable or damaged, return:
        if self.invulnerable || self.damaged {return}
        // Remove one from our health pool
        self.health -= 1
        if self.health == 0 {
            // If we are out of health, run the die function:
            die()
        } else {
            // Run the take damage animation:
            self.run(self.damageAnimation)
        }
    }
}
