//
//  GameScene.swift
//  Milestone Project 16-18 - Shooting Gallery
//
//  Created by Stefan Storm on 2024/10/04.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = Player()
    var timerIsRunning = false
    var startTime: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    var enemyCount = 10
    let defaults = UserDefaults.standard
    var bestTimeSaved = ""

    
    let background : SKSpriteNode = {
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        return bg
    }()
    
    
    var time : SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Copperplate")
        label.position = CGPoint(x: 300, y: 1000)
        label.horizontalAlignmentMode = .center
        label.fontSize = 100
        label.zPosition = 2
        label.text = "00:00.00"
        label.fontColor = .black
        return label
    }()
    
    
    var bestTime : SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Copperplate")
        label.position = CGPoint(x: 1500, y: 1000)
        label.horizontalAlignmentMode = .left
        label.fontSize = 100
        label.zPosition = 2
        label.text = "00:00.00"
        label.fontColor = .black
        return label
    }()

    
    override func didMove(to view: SKView) {
        
        let firstLoad = defaults.bool(forKey: "firstLoad")
        if !firstLoad {
            defaults.set(true, forKey: "firstLoad")
            defaults.setValue("00:59.99", forKey: "bestTime")
        }
        
        setupScene()
    }
    
    
    func setupScene(){
        view?.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.timerIsRunning = true
            self.view?.isUserInteractionEnabled = true
        }
        
        startTime = 0
        elapsedTime = 0
        enemyCount = 10
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        background.size.width = self.size.width
        background.size.height = self.size.height
        addChild(background)
        
        player.configurePlayer(at: CGPoint(x: 0, y: 0))
        addChild(player)
        addChild(time)
        
        if let savedTime = defaults.string(forKey: "bestTime"){
            bestTimeSaved = savedTime
        }
        addChild(bestTime)
        bestTime.text = "Best time: \(bestTimeSaved)"
    
        var objectPosition = 200
        var enemyPosition = 180
        for i in 1...10{
            
            let randomYPosition = Int.random(in: 100...300)
            
            let object = ConcealmentObject()
            object.configureObjects(at: CGPoint(x: Double(objectPosition), y: Double(randomYPosition)))
            addChild(object)
            
            let enemy = Enemy()
            enemy.configureEnemy(at: CGPoint(x: Double(enemyPosition), y: Double(randomYPosition + 75)))
            addChild(enemy)
            
            objectPosition += Int.random(in: 200...250)
            enemyPosition += Int.random(in: 200...250)
            
            if i % 2 == 0{
                enemy.move()
            }
        }
        
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let position = touch.location(in: self)
        let tappedNodes = nodes(at: position)
        
        for node in tappedNodes {
            run(SKAction.playSoundFileNamed("Gunshot.m4a", waitForCompletion:false))
            player.position = position
            
            //Improve precision of tap
            if let spriteNode = node as? SKSpriteNode {
                let detectionArea = CGRect(x: spriteNode.position.x - spriteNode.size.width / 4,
                                           y: spriteNode.position.y - spriteNode.size.height / 4,
                                           width: spriteNode.size.width / 2,
                                           height: spriteNode.size.height / 2)
                
                if detectionArea.contains(position) {
 
                    if node.name == "object"{
                        player.createDustEmitter()
                        return
                    }
                    
                    if node.name == "enemy" {
                        guard let enemy = node.parent as? Enemy else {return}
                        //Disable multiple hits on one target.
                        if enemy.ishit{return}
                        enemy.hit()
                        enemyCount -= 1
                        player.createDustEmitter()
                        
                        if enemyCount == 0{
                            checkTimeRestartGame()

                        }
                    }
                    
                    
                }
            }
        }    
    }
    
    
    func checkTimeRestartGame(){
        
        timerIsRunning = false
     
        if let savedTime = defaults.string(forKey: "bestTime"){
            
            let savedTimeInSecond = timeStringToSeconds(timeString: savedTime)
            let elapsedTimeInTimeInterval = formatTime(time: elapsedTime)
            let elapsedTimeInSeconds = timeStringToSeconds(timeString: elapsedTimeInTimeInterval)!
            
            if elapsedTimeInSeconds < savedTimeInSecond! {
                defaults.setValue(formatTime(time: elapsedTime), forKey: "bestTime")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.removeAllChildren()
                self.setupScene()
            }
        }

    }
    

    override func update(_ currentTime: TimeInterval) {
        if timerIsRunning {
            if startTime == 0 {
                startTime = currentTime
            }
            elapsedTime = currentTime - startTime
            time.text = formatTime(time: elapsedTime)
        }
    }
    
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time - floor(time)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    
    func timeStringToSeconds(timeString: String) -> TimeInterval? {
        let components = timeString.split(separator: ":")
        
        guard components.count == 2,
              let minutes = Int(components[0]) else {
            return nil
        }
        
        let secondsAndMilliseconds = components[1].split(separator: ".")
        
        guard secondsAndMilliseconds.count == 2,
              let seconds = Int(secondsAndMilliseconds[0]),
              let milliseconds = Int(secondsAndMilliseconds[1]) else {
            return nil
        }
        
        let totalSeconds = TimeInterval(minutes * 60) + TimeInterval(seconds) + TimeInterval(milliseconds) / 100
        return totalSeconds
    }

}
