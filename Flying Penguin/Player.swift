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
        
        // Grant a momentary reprieve from gravity:
        self.physicsBody?.affectedByGravity = false
        // Add some slight upward velocity:
        self.physicsBody?.velocity.dy = 80
        // Create a SKAction to start gravity after a small delay:
        let startGravitySequence = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.run {
                self.physicsBody?.affectedByGravity = true
            }
            ])
        self.run(startGravitySequence)
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
        
        // --- Create the taking damage animation ---
        let damageStart = SKAction.run {
            // Allow the penguin to pass through enemies:
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
        }
        
        // Create an opacity pulse, slow at first and fast at the end:
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
            ])
        // Return the penguin to normal:
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            // Turn off the newly damaged flag:
            self.damaged = false
        }
        // Store the whole sequence in the damageAnimation property:
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeOutAndIn,
            damageEnd
            ])
        
        // --- Create the death animation ---
        let startDie = SKAction.run {
            // Switch to the death texture with X eyes:
            self.texture = self.textureAtlas.textureNamed("pierre-dead")
            // Suspend the penguin in space:
            self.physicsBody?.affectedByGravity = false
            // Stop any movement:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        let endDie = SKAction.run {
            // Turn gravity back on:
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            // Scale the penguin bigger:
            SKAction.scale(to: 1.3, duration: 0.5),
            // Use the waitForDuration action to provide a short pause:
            SKAction.wait(forDuration: 0.5),
            // Rotate the penguin on to his back:
            SKAction.rotate(toAngle: 3, duration: 1.5),
            SKAction.wait(forDuration: 0.5),
            endDie
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onTap() {
        //print(" tapping on penguin")
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
        
        // Alert the GameScene
        if let gameScene = self.parent as? GameScene {
            gameScene.gameOver()
        }
    }
    
    func takeDamage() {
        // If invulnerable or damaged, return:
        if self.invulnerable || self.damaged {return}
        // Set the damaged state to true after being hit:
        self.damaged = true
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
    
    func starPower() {
        // Remove any existing star power-up animation, if
        // the player is already under the power of star
        self.removeAction(forKey: "starPower")
        // Grant great forward speed:
        self.forwardVelocity = 400
        // Make hte player invulnerable:
        self.invulnerable = true
        // Create a sequence to scale the player larger,
        // wait 8 seconds, then scale back down and turn off
        // invulnerability, returning the player to normal:
        let starSequence = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.3),
            SKAction.wait(forDuration: 8),
            SKAction.scale(to: 1, duration: 1),
            SKAction.run {
                self.forwardVelocity = 200
                self.invulnerable = false
            }
            ])
        // Execute the sequence:
        self.run(starSequence, withKey: "starPower")
    }
    
}
