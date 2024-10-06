//
//  Player.swift
//  Milestone Project 16-18 - Shooting Gallery
//
//  Created by Stefan Storm on 2024/10/05.
//

import UIKit
import SpriteKit

class Player: SKNode {

    var object : SKSpriteNode!
    
    
    func configurePlayer(at position: CGPoint){
        object = SKSpriteNode(imageNamed: "crosshair")
        object.position = position
        object.size = CGSize(width: object.size.width / 10, height: object.size.height / 10)
        object.zPosition = 2
        object.name = "player"
        addChild(object)

    }
    
    
    func createDustEmitter(){
        if let dust = SKEmitterNode(fileNamed: "DustEmitter"){
            dust.position = object.position
            dust.zPosition = 2
            addChild(dust)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                dust.removeFromParent()
            }
        }
    }
    
}
