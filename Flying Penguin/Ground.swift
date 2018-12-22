//
//  Ground.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/19.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = CGSize.zero
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1)
    
    func createChildren() {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        let texture = textureAtlas.textureNamed("ground")
        
        var tileCount: CGFloat = 0
        let tileSize = CGSize(width: 35, height: 300)
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            tileCount += 1
        }
        
        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
        jumpWidth = tileSize.width * floor(tileCount / 3)
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        let groundJumpPosition = jumpWidth * jumpCount
        if playerProgress >= groundJumpPosition {
            self.position.x += jumpWidth
            jumpCount += 1
        }
    }
    
    func onTap() {
        
    }
    
    
}
