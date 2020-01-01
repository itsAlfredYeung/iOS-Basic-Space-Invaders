//
//  GameOverScene.swift
//  DPS936-FinalProject
//
//  Created by Alfred Yeung and Zu Chao Xiong on 2019-04-04.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var backBtnNode:SKSpriteNode!
    var gameOverScore:SKLabelNode!
    
    override func didMove(to view: SKView){
        
        backBtnNode = (self.childNode(withName: "BackButton") as! SKSpriteNode)
        gameOverScore = (self.childNode(withName: "ScoreAmount") as! SKLabelNode)
        
        gameOverScore.text = String(defaults.integer(forKey: "score\(getNumberCount())"))
    }
    
    func getNumberCount() -> Int{
        let counts = defaults.integer(forKey: "number")
        return counts
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "BackButton"{
                
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                
                if let scene = SKScene(fileNamed: "MenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: transition)
                }
                
                self.view?.ignoresSiblingOrder = true
                self.view?.showsFPS = true
                self.view?.showsNodeCount = true
            }
        }
    }
}
