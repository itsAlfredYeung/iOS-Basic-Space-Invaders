//
//  GameScene.swift
//  DPS936-FinalProject
//
//  Created by Alfred Yeung and Zu Chao Xiong on 2019-03-26.
//  Copyright © 2019 dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var lives: Int = 3 {
        didSet{
            livesLabel.text = "Lives"
        }
    }
    //PlayerShip Images for Lives
    let liveNode1 = SKSpriteNode(imageNamed: "playerShip")
    let liveNode2 = SKSpriteNode(imageNamed: "playerShip")
    let liveNode3 = SKSpriteNode(imageNamed: "playerShip")
    
    var livesArray:[SKSpriteNode]! //Place all PlayerShip Images into an array
    
    var enemyArray = ["enemyShip1", "enemyShip2", "enemyShip3", "enemyShip4"] //Different types of Enemy Ships to spawn
    
    var gameTimer: Timer! //Timer for Enemy Spawning
    var enemyShootTimer: Timer! //Timer for Enemy Shooting
    
    let playerCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
    let playerProjectileCategory: UInt32 = 0x1 << 2
    let enemyProjectileCategory: UInt32 = 0x1 << 3
    
    override func didMove(to view: SKView) {
        //BGM
        let backgroundSound = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        self.addChild(backgroundSound)
        
        //Background
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: self.frame.size.height / 2) //iPhone 6 / 7 (Can modify later)
        starfield.advanceSimulationTime(10) //Start somewhere in middle so the entire field is already shown in the entire screen
        self.addChild(starfield)
        
        starfield.zPosition = -1 //set to very bottom/back most/background
        
        player = SKSpriteNode(imageNamed: "playerShip") //Player Ship
        player.size.height = 100
        player.size.width = 100
        
        player.position = CGPoint(x: 0, y: -self.frame.size.height / 2 + player.size.height / 2 + 100) //Position
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = enemyProjectileCategory | enemyCategory
        player.physicsBody?.collisionBitMask = 0
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //Set Score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: -self.frame.size.width / 2 + player.size.height / 2 + 150, y: self.frame.size.height / 2 + player.size.height / 2 - 150)
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        //Set Lives
        addLives()
        livesLabel = SKLabelNode(text: "Lives")
        livesLabel.position = CGPoint(x: self.frame.size.width / 2 - player.size.height / 2 - 110, y: self.frame.size.height / 2 + player.size.height / 2 - 150)
        livesLabel.fontSize = 40
        livesLabel.fontColor = UIColor.white
        lives = 3
        
        liveNode1.size.height = 75
        liveNode1.size.width = 75
        
        liveNode2.size.height = 75
        liveNode2.size.width = 75
        
        liveNode3.size.height = 75
        liveNode3.size.width = 75
        
        self.addChild(scoreLabel)
        self.addChild(livesLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true) //Enemy Spawning
    }
    
    func addLives() { //Used for initial Player Lives images
        livesArray = [SKSpriteNode]()
        
        liveNode1.position = CGPoint(x: self.frame.size.width / 2 + player.size.height / 2 - 160, y: self.frame.size.height / 2 + player.size.height / 2 - 200)
        liveNode1.zPosition = -2
        self.addChild(liveNode1)
        livesArray.append(liveNode1)
        
        liveNode2.position = CGPoint(x: self.frame.size.width / 2 + player.size.height / 2 - 220, y: self.frame.size.height / 2 + player.size.height / 2 - 200)
        liveNode2.zPosition = -2
        self.addChild(liveNode2)
        livesArray.append(liveNode2)
        
        liveNode3.position = CGPoint(x: self.frame.size.width / 2 + player.size.height / 2 - 270, y: self.frame.size.height / 2 + player.size.height / 2 - 200)
        liveNode3.zPosition = -2
        self.addChild(liveNode3)
        livesArray.append(liveNode3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = CGPoint(x: touch.location(in: self).x, y: player.position.y)
            let moveAction = SKAction.move(to: location, duration: 0.5)
            player.run(moveAction) //Player will move to location (X-Axis only)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            player.position.x = touch.location(in: self).x //Player follows finger when dragging (X-Axis only)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireProjectilePlayer() //Player shooting
    }
    
    @objc func spawnEnemy () { //Enemy Spawning logic
        enemyArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemyArray) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: enemyArray[0])
        enemy.size.height = 75
        enemy.size.width = 75
        
        let randomEnemyPosition = GKRandomDistribution(lowestValue: -270, highestValue: 270) //random values for X - value spawn
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height - 500) //enemy spawn location
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = playerProjectileCategory | playerCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        let animationDurationMovement: TimeInterval = 6
        
        var actionArrayMovement = [SKAction]()
        
        actionArrayMovement.append(SKAction.move(to: CGPoint(x: position, y: -self.frame.size.height / 2 + enemy.size.height), duration: animationDurationMovement))
        actionArrayMovement.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArrayMovement))
        
        //Enemy Shooting
        
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 1 ... 4)))
        let run = SKAction.run {
            self.fireProjectileEnemy(enemyNode: enemy)
        }
        
        enemy.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
    }
    
    func fireProjectilePlayer(){ //Player Shooting logic
        self.run(SKAction.playSoundFileNamed("projectile.mp3", waitForCompletion: false))
        
        let projectileNode = SKSpriteNode(imageNamed: "spark")
        projectileNode.size.height = 30
        projectileNode.size.width = 30
        projectileNode.position = player.position
        projectileNode.position.y += 5
        
        projectileNode.physicsBody = SKPhysicsBody(circleOfRadius: projectileNode.size.width / 2)
        projectileNode.physicsBody?.isDynamic = true
        
        projectileNode.physicsBody?.categoryBitMask = playerProjectileCategory
        projectileNode.physicsBody?.contactTestBitMask = enemyCategory
        projectileNode.physicsBody?.collisionBitMask = 0
        projectileNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(projectileNode)
        
        let animationDuration: TimeInterval = 2
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        projectileNode.run(SKAction.sequence(actionArray))
    }
    
    func fireProjectileEnemy(enemyNode: SKSpriteNode){ //Enemy Shooting logic
        self.run(SKAction.playSoundFileNamed("projectile.mp3", waitForCompletion: false))
        
        let projectileNode = SKSpriteNode(imageNamed: "torpedo")
        projectileNode.position = enemyNode.position
        projectileNode.position.y -= 10
        
        projectileNode.physicsBody = SKPhysicsBody(circleOfRadius: projectileNode.size.width / 2)
        projectileNode.physicsBody?.isDynamic = true
        
        projectileNode.physicsBody?.categoryBitMask = enemyProjectileCategory
        projectileNode.physicsBody?.contactTestBitMask = playerCategory
        projectileNode.physicsBody?.collisionBitMask = 0
        projectileNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(projectileNode)
        
        let animationDurationShot: TimeInterval = TimeInterval(Int.random(in: 2 ... 3))
        
        var actionArrayShot = [SKAction]()
        
        actionArrayShot.append(SKAction.move(to: CGPoint(x: enemyNode.position.x, y: -self.frame.size.height - 10), duration: animationDurationShot))
        actionArrayShot.append(SKAction.removeFromParent())
        
        projectileNode.run(SKAction.sequence(actionArrayShot))
    }
    
    func didBegin(_ contact: SKPhysicsContact) { //Contact logic
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == playerProjectileCategory && secondBody.categoryBitMask == enemyCategory {
            projectileCollideWithEnemy(projectileNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode) //PlayerProjectile + EnemyShip
        }
        
        if firstBody.categoryBitMask == enemyProjectileCategory && secondBody.categoryBitMask == playerCategory {
            enemyCollideWithPlayer(projectileNode: firstBody.node as! SKSpriteNode, playerNode: secondBody.node as! SKSpriteNode) //EnemyProjectile + PlayerShip
        }
        
        if firstBody.categoryBitMask == enemyCategory && secondBody.categoryBitMask == playerCategory {
            enemyCollideWithPlayer(projectileNode: firstBody.node as! SKSpriteNode, playerNode: secondBody.node as! SKSpriteNode) //EnemyShip + PlayerShip
        }
    }
    
    func projectileCollideWithEnemy (projectileNode: SKSpriteNode, enemyNode: SKSpriteNode){
        //PlayerBullet hits Enemy
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = enemyNode.position
        self.addChild(explosion!)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        projectileNode.removeFromParent()
        enemyNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
        
        score += 10
    }
    
    func enemyCollideWithPlayer (projectileNode: SKSpriteNode, playerNode: SKSpriteNode){
        //Enemy hits Player
        //EnemyBullet hits Player
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = playerNode.position
        self.addChild(explosion!)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        projectileNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
        
        lives -= 1

        if lives <= 0 { //GameOver
            liveNode3.removeFromParent()
            
            lives = 0 //Incase hit by multiple things at same time
            
            let transition = SKTransition.flipHorizontal(withDuration: 1)
            
            //Save score
            defaults.set(score, forKey: "score\(getNumberCount())")
            
            //Move to GameOver Screen
            if let scene = SKScene(fileNamed: "GameOverScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                self.view?.presentScene(scene, transition: transition)
            }
            
            self.view?.ignoresSiblingOrder = true
            self.view?.showsFPS = true
            self.view?.showsNodeCount = true
        }
        else{
            livesArray.remove(at: 0)
            
            if lives == 2 { //2 Lives Remains, 2 Life Icons
                liveNode1.removeFromParent()
            }
            else if lives == 1 { //1 Life Remains, 1 Life Icon
                liveNode2.removeFromParent()
            }
        }
    }
    
    func getNumberCount() -> Int{
        let counts = defaults.integer(forKey: "number")
        return counts
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
