//
//  Enemy.swift
//  Milestone Project 16-18 - Shooting Gallery
//
//  Created by Stefan Storm on 2024/10/05.
//

import UIKit
import SpriteKit

class Enemy: SKNode {
    
    
    var object : SKSpriteNode!
    var ishit = false
    
    func configureEnemy(at position: CGPoint){
        object = SKSpriteNode(imageNamed: "target")
        object.position = position
        object.size = CGSize(width: object.size.width / 5, height: object.size.height / 5)
        object.zPosition = 0
        object.name = "enemy"
        addChild(object)
    }
    
    
    func move(){
        let moveLeft = SKAction.moveBy(x: 100, y: 0, duration: 2)
        let moveRight = SKAction.moveBy(x: -100, y: 0, duration: 2)
        let sequence = SKAction.sequence([moveLeft,moveRight])
        let repeatForever = SKAction.repeatForever(sequence)
        object.run(repeatForever)
    }
    
    
    func hit(){
        object.isUserInteractionEnabled = false
        ishit = true
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.scaleY(to: 0.5, duration: 0.5)
        let alpha = SKAction.fadeAlpha(by: 1, duration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([delay,hide,alpha, remove])
        object.run(sequence)
    }

}
