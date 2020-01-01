//
//  TopTenScene.swift
//  DPS936-FinalProject
//
//  Created by Alfred Yeung and Zu Chao Xiong on 2019-04-08.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SpriteKit

struct DataItem {
    let user: String
    let score: Int
}

var totalArray = [DataItem]()

class TopTenScene: SKScene {
    var backBtnNode:SKSpriteNode!
    var rankLabel:SKLabelNode!
    var nameLabel:SKLabelNode!
    var scoreLabel:SKLabelNode!
    
    override func didMove(to view: SKView){
        //BGM
        let backgroundSound = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        self.addChild(backgroundSound)
        
        backBtnNode = (self.childNode(withName: "BackButton") as! SKSpriteNode)
        rankLabel = (self.childNode(withName: "Rank") as! SKLabelNode)
        nameLabel = (self.childNode(withName: "Name") as! SKLabelNode)
        scoreLabel = (self.childNode(withName: "Score") as! SKLabelNode)
        
        let count = defaults.integer(forKey: "number")
        
        totalArray.removeAll()
        
        if count > 0 {
            for i in 1 ... count { //add all Scores to an array
                let user = defaults.object(forKey: "username\(i)")
                let score = defaults.integer(forKey: "score\(i)")

                totalArray.append(DataItem(user: user as! String, score: score))
                totalArray.sort{ $0.score > $1.score }
            }
            
            for j in 1 ... totalArray.count {
                if j == 1 {
                    rankLabel.text = rankLabel.text! + "1\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[0].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[0].score)\n"
                }
                if j == 2 {
                    rankLabel.text = rankLabel.text! + "2\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[1].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[1].score)\n"
                }
                if j == 3 {
                    rankLabel.text = rankLabel.text! + "3\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[2].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[2].score)\n"
                }
                if j == 4 {
                    rankLabel.text = rankLabel.text! + "4\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[3].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[3].score)\n"
                }
                if j == 5 {
                    rankLabel.text = rankLabel.text! + "5\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[4].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[4].score)\n"
                }
                if j == 6 {
                    rankLabel.text = rankLabel.text! + "6\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[5].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[5].score)\n"
                }
                if j == 7 {
                    rankLabel.text = rankLabel.text! + "7\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[6].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[6].score)\n"
                }
                if j == 8 {
                    rankLabel.text = rankLabel.text! + "8\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[7].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[7].score)\n"
                }
                if j == 9 {
                    rankLabel.text = rankLabel.text! + "9\n"
                    nameLabel.text = nameLabel.text! + "\(totalArray[8].user)\n"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[8].score)\n"
                }
                if j == 10 {
                    rankLabel.text = rankLabel.text! + "10"
                    nameLabel.text = nameLabel.text! + "\(totalArray[9].user)"
                    scoreLabel.text = scoreLabel.text! + "\(totalArray[9].score)"
                }
                if j >= 11 {
                    break
                }
            }
        }
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
