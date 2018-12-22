//
//  MadFly.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/22.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 61, height: 29)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(flyAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
        ]
        
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        
    }
    
    
}
