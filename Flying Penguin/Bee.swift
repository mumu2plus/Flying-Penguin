//
//  Bee.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/19.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Bee: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimations()
        self.run(flyAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("bee"),
                                     textureAtlas.textureNamed("bee-fly")]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        
    }
}
