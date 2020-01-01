//
//  MenuScene.swift
//  DPS936-FinalProject
//
//  Created by Alfred Yeung and Zu Chao Xiong on 2019-04-03.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SpriteKit

protocol TransitionDelegate: SKSceneDelegate {
    func showAlert(title:String,message:String)
    func handleLoginBtn(username:String)
}

let defaults = UserDefaults.standard

class MenuScene: SKScene, UITextFieldDelegate {
    var starfield:SKEmitterNode!
    
    var newGameBtnNode:SKSpriteNode!
    var topTenBtnNode:SKSpriteNode!
    var exitBtnNode:SKSpriteNode!
    
    var usernameTextField:UITextField!
    
    override func didMove(to view: SKView){
        //BGM
        let backgroundSound = SKAudioNode(fileNamed: "backgroundMusic.mp3")
        self.addChild(backgroundSound)
        
        starfield = (self.childNode(withName: "startfield") as! SKEmitterNode)
        starfield.advanceSimulationTime(10)
        
        newGameBtnNode = (self.childNode(withName: "newGameBtn") as! SKSpriteNode)
        topTenBtnNode = (self.childNode(withName: "topTenBtn") as! SKSpriteNode)
        exitBtnNode = (self.childNode(withName: "exitBtn") as! SKSpriteNode)
        
        guard let view = self.view else { return }
        let originX = (view.frame.size.width - view.frame.size.width/1.5)/2
        usernameTextField = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5, width: view.frame.size.width/1.5, height: 30))
        customize(textField: usernameTextField, placeholder: "Enter username (not blank)")
        view.addSubview(usernameTextField)
        
        //For removing records
        
//        let count = getNumberCount()
//        for i in 1 ... count {
//            defaults.removeObject(forKey: "username\(i)")
//            defaults.removeObject(forKey: "score\(i)")
//            
//        }
//        defaults.removeObject(forKey: "number")
    }
    
    func customize(textField:UITextField, placeholder:String , isSecureTextEntry:Bool = false) {
        let paddingView = UIView(frame:CGRect(x:0,y: 0,width: 10,height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.leftViewMode = UITextField.ViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .white
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = self
    }
    
    func updateNumberCount(){
        let counts = getNumberCount() + 1
        defaults.set(counts, forKey: "number")
    }
    
    func getNumberCount() -> Int{
        let counts = defaults.integer(forKey: "number")
        return counts
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            //New Game
            if nodesArray.first?.name == "newGameBtn"{
                
                if (usernameTextField.text != ""){
                    updateNumberCount()
                    defaults.set(getNumberCount(), forKey: "number")
                    
                    defaults.set(usernameTextField.text, forKey: "username\(getNumberCount())")
                    
                    usernameTextField.removeFromSuperview()
                    
                    let transition = SKTransition.flipHorizontal(withDuration: 1)
                    
                    if let scene = SKScene(fileNamed: "GameScene") {
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
            //Top Ten (Highscores)
            else if nodesArray.first?.name == "topTenBtn"{
                usernameTextField.removeFromSuperview()
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                
                if let scene = SKScene(fileNamed: "TopTenScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: transition)
                }
                
                self.view?.ignoresSiblingOrder = true
                self.view?.showsFPS = true
                self.view?.showsNodeCount = true
            }
            //Exit
            else if nodesArray.first?.name == "exitBtn"{
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            }
        }
    }

}
