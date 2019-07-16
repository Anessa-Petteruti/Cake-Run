//
//  GameScene.swift
//  Cake Run
//
//  Created by Anessa Petteruti on 8/5/18.
//  Copyright © 2018 Anessa Petteruti. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewControllerView: UIViewController?

    var viewController: GameViewController?
    
    var man : SKSpriteNode?
    
    var cakeTimer : Timer?
    var rottenEggTimer : Timer?
    
    var ceiling : SKSpriteNode?
    var scoreLabel : SKLabelNode?
    var life1 : SKSpriteNode?
    var life2 : SKSpriteNode?
    var life3 : SKSpriteNode?
    var livesArray : [SKSpriteNode] = [SKSpriteNode]()
    
    var gameOverBackdrop : SKSpriteNode?
    var gameOverLabel : SKLabelNode?
    var yourScoreLabel : SKLabelNode?
    var finalScoreLabel : SKLabelNode?
    var playButton : SKSpriteNode?

    
    let manCategory : UInt32 = 0x1 << 1
    let cakeCategory : UInt32 = 0x1 << 2
    let rottenEggCategory : UInt32 = 0x1 << 3
    let groundAndCeilingCategory : UInt32 = 0x1 << 4
    
    var score = 0
    var livesCounter = 3
    
    var audioPlayerGame = AVAudioPlayer()
    var cakeAudio = AVAudioPlayer()
    var rottenEggAudio = AVAudioPlayer()
    var gameOverAudio = AVAudioPlayer()
    
    var countdownTime = 5
    var countdownTimer = Timer()
    var countdownLabel : SKLabelNode?
    
    
    var homeButton : SKSpriteNode?
    
    var pauseButton : SKSpriteNode?
    var pausedLabel : SKLabelNode?
    
    var isStopped = false

    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .aspectFit
        
        countdown()

        countdownTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(GameScene.countdown), userInfo: nil, repeats: true)
        
        countdownLabel?.alpha = 1
        
//        self.pauseButton?.alpha = 0
//        self.pauseButton?.removeFromParent()
        
        self.homeButton = SKSpriteNode(imageNamed: "home (4)")
//        self.homeButton?.setScale(1.25)
        self.homeButton?.size = CGSize(width: self.frame.maxY - 580, height: self.frame.maxY - 580)
        self.homeButton?.position = CGPoint(x: 300, y: -610)
        self.homeButton?.alpha = 5
        self.homeButton?.zPosition = 1
        
        self.addChild(self.homeButton!)
        


        
        physicsWorld.contactDelegate = self

        
        let audioPath = Bundle.main.path(forResource: "playingAudio", ofType: "mp3")
        
        do {
            try audioPlayerGame = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayerGame.volume = 0.5
            audioPlayerGame.play()
            audioPlayerGame.numberOfLoops = -1
        }
        catch {
            print(error)
        }
        
        man = childNode(withName: "man") as? SKSpriteNode
        man?.physicsBody?.categoryBitMask = manCategory
        man?.physicsBody?.contactTestBitMask = cakeCategory | rottenEggCategory
        man?.physicsBody?.collisionBitMask = groundAndCeilingCategory
        var manRun : [SKTexture] = []
        for number in 1...6 {
            manRun.append(SKTexture(imageNamed: "frame-\(number)"))
        }
        man?.run(SKAction.repeatForever(SKAction.animate(with: manRun, timePerFrame: 0.07)))
            
            
        ceiling = childNode(withName: "ceiling") as? SKSpriteNode
        ceiling?.physicsBody?.categoryBitMask = groundAndCeilingCategory
        ceiling?.physicsBody?.collisionBitMask = manCategory
            
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.fontName = "knewave"
        scoreLabel?.zPosition = 1
            
        startTimers()
        createTile()
        getLives()
        
        
    }
    
    
    @objc func countdown() {
        
        if countdownTime > 0 {
            scene?.isPaused = true
            scene?.alpha = 0.8
            countdownTime -= 1
            countdownLabel?.text = String(countdownTime)
            countdownLabel?.alpha = 2
            countdownLabel?.zPosition = 2
            countdownLabel = childNode(withName: "countdownLabel") as? SKLabelNode
            countdownLabel?.fontName = "knewave"
            countdownLabel?.fontSize = 450
            countdownLabel?.position = CGPoint(x: 0, y: 0)
            cakeTimer?.invalidate()
            rottenEggTimer?.invalidate()
            
            self.isStopped = true
            
        }
        
        if countdownTime == 0 {

            self.pauseButton = SKSpriteNode(imageNamed: "pause-2")
//            self.pauseButton?.setScale(1.25)
            self.pauseButton?.size = CGSize(width: self.frame.maxY - 575, height: self.frame.maxY - 575)
            self.pauseButton?.position = CGPoint(x: -300, y: -610)
            self.pauseButton?.alpha = 5
            self.pauseButton?.zPosition = 1

            self.addChild(self.pauseButton!)
            
            self.isStopped = false

            scene?.alpha = 1
            countdownTimer.invalidate()
            scene?.isPaused = false
            startTimers()
            countdownLabel?.removeFromParent()
        }
    }
    
    func getLives() {
        
        life1 = SKSpriteNode(imageNamed: "life1")
        life2 = SKSpriteNode(imageNamed: "life2")
        life3 = SKSpriteNode(imageNamed: "life3")
        
        if life1 != nil {
            livesArray.append(life1!)
            self.addChild(life1!)
        }
        
        if life2 != nil {
            livesArray.append(life2!)
            self.addChild(life2!)
        }
        
        if life3 != nil {
            livesArray.append(life3!)
            self.addChild(life3!)
        }
        
        
        life1?.zPosition = 1
        life2?.zPosition = 1
        life3?.zPosition = 1
        
        life1?.position = CGPoint(x: -315, y: 565)
        life2?.position = CGPoint(x: -235, y: 565)
        life3?.position = CGPoint(x: -155, y: 565)
        
        life1?.setScale(0.5)
        life2?.setScale(0.5)
        life3?.setScale(0.5)
        
    }
    
    func createTile() {
        let sizingTile = SKSpriteNode(imageNamed: "tile")
        let numberOfTiles = Int(size.width / sizingTile.size.width) + 1
        for number in 0...numberOfTiles {
            let tile = SKSpriteNode(imageNamed: "tile")
            tile.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
            tile.physicsBody?.categoryBitMask = groundAndCeilingCategory
            tile.physicsBody?.collisionBitMask = manCategory
            tile.physicsBody?.affectedByGravity = false
            tile.physicsBody?.isDynamic = false
            addChild(tile)
            
            let tileX = -size.width / 2 + tile.size.width / 2 + tile.size.width * CGFloat(number)
            tile.position = CGPoint(x: tileX, y: -size.height / 2 + tile.size.height / 2 - 16)
            let speed = 100.0
            let firstMoveLeft = SKAction.moveBy(x: -tile.size.width - tile.size.width * CGFloat(number), y: 0, duration: TimeInterval(tile.size.width + tile.size.width * CGFloat(number)) / speed)
            
            let resetTile = SKAction.moveBy(x: size.width + tile.size.width, y: 0, duration: 0)
            let tileFullMove = SKAction.moveBy(x: -size.width - tile.size.width, y: 0, duration: TimeInterval(size.width + tile.size.width) / speed)
            let tileMovingForever = SKAction.repeatForever(SKAction.sequence([tileFullMove,resetTile]))
            
            tile.run(SKAction.sequence([firstMoveLeft,resetTile,tileMovingForever]))
        }
    }
    
    func startTimers() {
        cakeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createCake()
        })
        
        rottenEggTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.createRottenEgg()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if scene?.isPaused == false || self.isStopped == false {
            man?.physicsBody?.applyForce(CGVector(dx: 0, dy: 90000))
        }
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "playbutton" {
                    // Restart the game
                    score = 0
                    playButton?.removeFromParent()
                    gameOverBackdrop?.removeFromParent()
                    gameOverLabel?.removeFromParent()
                    finalScoreLabel?.removeFromParent()
                    yourScoreLabel?.removeFromParent()
                    scene?.alpha = 1
                    scene?.isPaused = false
                    self.isStopped = false
                    homeButton?.alpha = 5
                    homeButton?.zPosition = 2

                    self.pauseButton = SKSpriteNode(imageNamed: "pause-2")
                    //            self.pauseButton?.setScale(1.25)
                    self.pauseButton?.size = CGSize(width: self.frame.maxY - 575, height: self.frame.maxY - 575)
                    self.pauseButton?.position = CGPoint(x: -300, y: -610)
                    self.pauseButton?.alpha = 5
                    self.pauseButton?.zPosition = 1
                    
                    self.addChild(self.pauseButton!)

                    
                    if life1 != nil {
                        livesArray.append(life1!)
                        self.addChild(life1!)
                    }
                    
                    if life2 != nil {
                        livesArray.append(life2!)
                        self.addChild(life2!)
                    }
                    
                    if life3 != nil {
                        livesArray.append(life3!)
                        self.addChild(life3!)
                    }
                    scoreLabel?.text = "Score: \(score)"
                    startTimers()
                }
                
                let touch = touches.first
                let touchLocation = touch!.location(in: self)
                // Check if the location of the touch is within the button's bounds
                if (self.homeButton?.contains(touchLocation))! {
                    print("tapped!")
                    audioPlayerGame.stop()
                    let backToHome = GameScene(fileNamed: "StartScene")
                    backToHome?.scaleMode = .aspectFit
                    self.scene?.view?.presentScene(backToHome)

                }
                if (self.pauseButton?.contains(touchLocation))! {
                    if self.isStopped {
                        self.pauseButton?.texture = SKTexture(imageNamed: "pause-2")
                        audioPlayerGame.volume = 1
                        scene?.alpha = 1
                        scene?.isPaused = false
                        self.isStopped = false
                        self.pausedLabel?.removeFromParent()
                    }
                    else {
                        self.pauseButton?.texture = SKTexture(imageNamed: "resume-2")
                        audioPlayerGame.volume = 0.2
                        scene?.alpha = 0.3
                        scene?.isPaused = true
                        self.isStopped = true
                        self.pausedLabel = SKLabelNode(text: "Paused")
                        self.pausedLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
                        self.pausedLabel?.fontSize = 100
                        self.pausedLabel?.fontName = "knewave"
                        self.pausedLabel?.zPosition = 1
                        self.pausedLabel?.alpha = 5
                        self.addChild(self.pausedLabel!)
                    }
                }

            }
        }
    }
    
    
    func createCake() {
        
        let cake = SKSpriteNode(imageNamed: "cake")
        
        cake.physicsBody = SKPhysicsBody(rectangleOf: cake.size)
        cake.physicsBody?.affectedByGravity = false
        cake.physicsBody?.categoryBitMask = cakeCategory
        cake.physicsBody?.contactTestBitMask = manCategory
        cake.physicsBody?.collisionBitMask = 0
        
        addChild(cake)
        
        let sizingTile = SKSpriteNode(imageNamed: "tile")
        
        let maxY = size.height / 2 - cake.size.height / 2
        let minY = -size.height / 2 + cake.size.height / 2 + sizingTile.size.height
        let range = maxY - minY
        let cakeY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        cake.position = CGPoint(x: size.width / 2 + cake.size.width / 2, y: cakeY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - cake.size.width, y: 0, duration: 4)
        
        cake.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        
    }
    
    func createRottenEgg() {
        let rottenEgg = SKSpriteNode(imageNamed: "egg")
        rottenEgg.physicsBody = SKPhysicsBody(rectangleOf: rottenEgg.size)
        rottenEgg.physicsBody?.affectedByGravity = false
        rottenEgg.physicsBody?.categoryBitMask = rottenEggCategory
        rottenEgg.physicsBody?.contactTestBitMask = manCategory
        rottenEgg.physicsBody?.collisionBitMask = 0
        addChild(rottenEgg)
        
        let sizingTile = SKSpriteNode(imageNamed: "tile")
        
        let maxY = size.height / 2 - rottenEgg.size.height / 2
        let minY = -size.height / 2 + rottenEgg.size.height / 2 + sizingTile.size.height
        let range = maxY - minY
        let rottenEggY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        rottenEgg.position = CGPoint(x: size.width / 2 + rottenEgg.size.width / 2, y: rottenEggY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - rottenEgg.size.width, y: 0, duration: 4)
        
        rottenEgg.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == cakeCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
            
            let cakeAudioPath = Bundle.main.path(forResource: "cakeSFX", ofType: "mp3")
            
            do {
                try cakeAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: cakeAudioPath!) as URL)
                cakeAudio.volume = 2
                cakeAudio.play()
            }
            catch {
                print(error)
            }
            
        }
        
        if contact.bodyB.categoryBitMask == cakeCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
            
            
            let cakeAudioPath = Bundle.main.path(forResource: "cakeSFX", ofType: "MP3")
            
            do {
                try cakeAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: cakeAudioPath!) as URL)
                cakeAudio.volume = 2
                cakeAudio.play()
            }
            catch {
                print(error)
            }
        }
        
        if contact.bodyA.categoryBitMask == rottenEggCategory {
            contact.bodyA.node?.removeFromParent()
            let rottenEggAudioPath = Bundle.main.path(forResource: "rottenEggSFX", ofType: "mp3")
            
            do {
                try rottenEggAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: rottenEggAudioPath!) as URL)
                rottenEggAudio.volume = 3
                rottenEggAudio.play()
            }
            catch {
                print(error)
            }
            
            if livesArray.count > 0 {
                
                let liveNode = self.livesArray.last
                liveNode!.removeFromParent()
                livesArray.removeLast()
            }
            
            if livesArray.count == 0 {
                gameOver()
            }
        }
        
        if contact.bodyB.categoryBitMask == rottenEggCategory {
            contact.bodyB.node?.removeFromParent()
            let rottenEggAudioPath = Bundle.main.path(forResource: "rottenEggSFX", ofType: "mp3")
            
            do {
                try rottenEggAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: rottenEggAudioPath!) as URL)
                rottenEggAudio.volume = 3
                rottenEggAudio.play()
            }
            catch {
                print(error)
            }
            
            if livesArray.count > 0 {
                
                let liveNode = self.livesArray.last
                liveNode!.removeFromParent()
                livesArray.removeLast()
            }
            
            if livesArray.count == 0 {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        
        scene?.isPaused = true
        self.isStopped = true
        
        cakeTimer?.invalidate()
        rottenEggTimer?.invalidate()
        
        scene?.alpha = 0.3
        
        let gameOverAudioPath = Bundle.main.path(forResource: "gameOverSFX", ofType: "mp3")
        
        do {
            try gameOverAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: gameOverAudioPath!) as URL)
            gameOverAudio.volume = 3
            gameOverAudio.play()
        }
        catch {
            print(error)
        }
        
        homeButton?.alpha = 0.5
        pauseButton?.alpha = 0.0

        
        gameOverBackdrop = SKSpriteNode(imageNamed: "gameOverBackdrop")
        gameOverBackdrop?.position = CGPoint(x: 0, y: 200)
        gameOverBackdrop?.name = "gameOverBackdrop"
        gameOverBackdrop?.setScale(0.8)
        gameOverBackdrop?.zPosition = 0.5
        gameOverBackdrop?.alpha = 5
        if gameOverBackdrop != nil {
            addChild(gameOverBackdrop!)
        }
        
        gameOverLabel = SKLabelNode(text: "You left Maurice hungry!")
        gameOverLabel?.position = CGPoint(x: 0, y: 350)
        gameOverLabel?.fontSize = 40
        gameOverLabel?.fontName = "knewave"
        gameOverLabel?.zPosition = 1
        gameOverLabel?.alpha = 5
        if gameOverLabel != nil {
            addChild(gameOverLabel!)
        }
        
        yourScoreLabel = SKLabelNode(text: "Your Score:")
        yourScoreLabel?.position = CGPoint(x: 0, y: 200)
        yourScoreLabel?.fontSize = 100
        yourScoreLabel?.fontName = "knewave"
        yourScoreLabel?.zPosition = 1
        yourScoreLabel?.alpha = 5
        if yourScoreLabel != nil {
            addChild(yourScoreLabel!)
        }
        
        finalScoreLabel = SKLabelNode(text: "\(score)")
        finalScoreLabel?.position = CGPoint(x: 0, y: 0)
        finalScoreLabel?.fontSize = 200
        finalScoreLabel?.fontName = "knewave"
        finalScoreLabel?.zPosition = 1
        finalScoreLabel?.alpha = 5
        if finalScoreLabel != nil {
            addChild(finalScoreLabel!)
        }
        
        playButton = SKSpriteNode(imageNamed: "playbutton")
        playButton?.position = CGPoint(x: 0, y: -350)
        playButton?.name = "playbutton"
        playButton?.zPosition = 1
        playButton?.alpha = 5
        addChild(playButton!)
    }
    
    
}
