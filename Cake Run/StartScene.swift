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

class StartScene: SKScene {
    
    var audioPlayer = AVAudioPlayer()

    var isPlaying = false
    
    var playButton : SKSpriteNode?
    var speakerButton : SKSpriteNode?

    var MainGuy = SKSpriteNode()
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()

    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = -1
        imageView.startAnimating()
    }
    
    override func didMove(to view: SKView) {
        
        let audioPath = Bundle.main.path(forResource: "cakeRunAudio", ofType: "mp3")
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
        catch {
            print(error)
        }
        
        let logo = SKSpriteNode(imageNamed: "ffceda")
        self.addChild(logo)
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        logo.size = CGSize(width: self.frame.maxY - 100, height: self.frame.maxY - 100)

        
        let underline = SKSpriteNode(imageNamed: "underline")
        underline.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(underline)

        
        let homeText = SKLabelNode(fontNamed: "knewave")
        homeText.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        homeText.text = "Help Maurice eat slices of cake, but avoid the rotten eggs!"
        homeText.fontSize = 50
//        homeText.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        homeText.horizontalAlignmentMode = .center
        
        homeText.numberOfLines = 2
        
        homeText.preferredMaxLayoutWidth = 600
        
        self.addChild(homeText)
        
        self.playButton = SKSpriteNode(imageNamed: "playbutton")
        self.playButton?.position = CGPoint(x: self.frame.midX + 150, y: self.frame.midY - 300)

        self.playButton?.shadowedBitMask = 0b0001
        
        self.addChild(self.playButton!)
        
        TextureAtlas = SKTextureAtlas(named: "Images")
        
        for i in 1...2{
            let Name = "gif-\(i)"
            TextureArray.append(SKTexture(imageNamed: Name))
        }
        
        MainGuy = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0])
        
        MainGuy.size = CGSize(width: self.frame.maxY - 500, height: self.frame.maxY - 400)
        MainGuy.position = CGPoint(x: self.frame.midX - 150, y: self.frame.midY - 325)
        self.addChild(MainGuy)
        
        MainGuy.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.7)))

        
        let playText = SKLabelNode(fontNamed: "knewave")
        playText.position = CGPoint(x: self.frame.midX + 150, y: self.frame.midY - 500)
        playText.text = "Play"
        playText.fontSize = 50
        playText.horizontalAlignmentMode = .center
        playText.preferredMaxLayoutWidth = 600
        
        self.addChild(playText)
        
        let mauriceText = SKLabelNode(fontNamed: "knewave")
        mauriceText.position = CGPoint(x: self.frame.midX + 75, y: self.frame.midY - 600)
        mauriceText.text = "Maurice"
        mauriceText.fontSize = 45
        mauriceText.horizontalAlignmentMode = .center
        mauriceText.preferredMaxLayoutWidth = 600
        
        self.addChild(mauriceText)
        
        let arrow = SKSpriteNode(imageNamed: "arrow")
        self.addChild(arrow)
        arrow.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY - 550)
        arrow.size = CGSize(width: self.frame.maxY - 500, height: self.frame.maxY - 550)
        
        self.speakerButton = SKSpriteNode(imageNamed: "audioOn")
        self.speakerButton?.position = CGPoint(x: self.frame.midX - 310, y: self.frame.midY - 610)
        self.speakerButton?.size = CGSize(width: self.frame.maxY - 600, height: self.frame.maxY - 600)

        
        self.speakerButton?.shadowedBitMask = 0b0001
        
        self.addChild(self.speakerButton!)



    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if ((self.playButton?.contains(touchLocation))!) {
            print("PLAY TAPPED!")
            audioPlayer.stop()
            let gameSceneTemp = GameScene(fileNamed: "GameScene")
//            gameSceneTemp?.size = self.frame.size
            gameSceneTemp?.scaleMode = .aspectFit
            self.scene?.view?.presentScene(gameSceneTemp) 
        }
        
        if isPlaying {
            self.speakerButton?.texture = SKTexture(imageNamed: "audioOn")
            audioPlayer.play()
            isPlaying = false
        }
        else {
            self.speakerButton?.texture = SKTexture(imageNamed: "audioOff")
            audioPlayer.stop()
            isPlaying = true
        }
        
        
 
    }
 
   

    
}
