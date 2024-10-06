//
//  concealmentObject.swift
//  Milestone Project 16-18 - Shooting Gallery
//
//  Created by Stefan Storm on 2024/10/05.
//

import UIKit
import SpriteKit

class ConcealmentObject: SKNode {
    
    var object : SKSpriteNode!
    var concealmentObjects : [String] = ["bush1","bush2","rock1","rock2","rock3"]
    
    func configureObjects(at position: CGPoint){
        
        object = SKSpriteNode(imageNamed: concealmentObjects.shuffled().first!)
        object.position = position
        object.size = CGSize(width: object.size.width / 3, height: object.size.height / 3)
        object.zPosition = 1
        object.name = "object"
        addChild(object)

    }
    
    
    

}
