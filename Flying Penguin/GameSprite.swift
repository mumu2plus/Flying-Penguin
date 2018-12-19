//
//  GameSprite.swift
//  Flying Penguin
//
//  Created by 加加林 on 2018/12/19.
//  Copyright © 2018 MuMu Games. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
    
    func onTap()
}
