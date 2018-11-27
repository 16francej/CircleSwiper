//
//  mainModel.swift
//  circleSwiper
//
//  Created by Joshua France on 12/28/17.
//  Copyright © 2017 Joshua France. All rights reserved.
//

import Foundation
import SpriteKit



class mainModel {
    private var score: Int
    var squareColor: UIColor = UIColor(red: 243.0/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1.0)
    var circleColor: UIColor = UIColor(red: 149/255.0, green: 225/255.0, blue: 211/255.0, alpha: 1.0)
    var background: UIColor = UIColor.white
    //UIColor(red: 234/255.0, green: 255/255.0, blue: 208/255.0, alpha: 0.0)
    var myTextColor: UIColor = UIColor(red: 84/255.0, green: 75/255.0, blue: 61/255.0, alpha: 1.0)
    
    var circles = [SKShapeNode]()
    var squares = [SKSpriteNode]()
    var isTouching = [Bool]()
    var touchPoints = [CGPoint]()
    
    var scoreLabel: SKLabelNode!
    
    var swipeToPlayLabel: SKLabelNode!
    
    init() {
        score = 0
    }
    
    func increment(){
        score += 1
    }
    
    func reset(){
        score = 0
    }
    
    func getScore() -> Int{
        return score
    }
    
    func getTimeDuration() -> Float{
        
        return Float(2.0*exp(-3.0*Double(getScore())))
    }
    
    func swipeToPlayExists(scene: SKScene) -> Bool{
        if(scene.children.contains(swipeToPlayLabel)){
            return true
        }
        else{
            return false
        }
    }
    
    func removeSwipeToPlay()
    {
        swipeToPlayLabel.removeFromParent()
    }
    
    func getRandXBall(view: SKView) -> CGFloat{
        let randomX = arc4random_uniform(UInt32(view.frame.size.width*2))
        return  CGFloat(randomX) - view.frame.size.width - view.frame.width/8}
    func getRandYBall(view: SKView) -> CGFloat{
        let randomY = arc4random_uniform(UInt32(view.frame.size.height*2 - view.frame.height/8))
        return CGFloat(randomY) - view.frame.size.height}
    
    func getRandXSquare(view: SKView) -> CGFloat{
        let randomX = arc4random_uniform(UInt32(view.frame.size.width*2))
        return  CGFloat(randomX) - view.frame.size.width}
    func getRandYSquare(view: SKView) -> CGFloat{
        let randomY = arc4random_uniform(UInt32(view.frame.size.height*2))
        return CGFloat(randomY) - view.frame.size.height}
    
    func endGame(view: SKView, scene: SKScene, textColor: UIColor){
        let endGameBoxTexture = SKTexture(image: #imageLiteral(resourceName: "gameOverBox"))
        let endGameBox = SKSpriteNode(texture: endGameBoxTexture)
        endGameBox.position = CGPoint(x: 0, y: view.frame.size.height/8)
        endGameBox.setScale(0.75)

        let playAgainTexture = SKTexture(image: #imageLiteral(resourceName: "playAgainButton"))
        playAgain = SKSpriteNode(texture: playAgainTexture)
        playAgain?.position = CGPoint(x: 0, y: -view.frame.size.height/32)
        playAgain?.setScale(0.75)
        playAgain?.zPosition = 2
        
        
        let highScoreDisplay = SKLabelNode(fontNamed: "Arial")
        if(UserDefaults.standard.object(forKey: "HighestScore") as? Int == nil){
            highScoreDisplay.text = "High Score: " + String(self.getScore())}
        else{
            highScoreDisplay.text = "High Score: " + String(UserDefaults.standard.object(forKey: "HighestScore") as! Int)}
        highScoreDisplay.zPosition = 1
        
        highScoreDisplay.position = CGPoint(x: 0, y: (playAgain?.position.y)! + endGameBox.size.height/4)
        highScoreDisplay.fontColor = textColor
        highScoreDisplay.fontSize = 54
        
        let yourScoreDisplay = SKLabelNode(fontNamed: "Arial")
        yourScoreDisplay.text = "Your Score: "  + String(self.getScore())
        yourScoreDisplay.position = CGPoint(x: 0, y: (playAgain?.position.y)! + 3*endGameBox.size.height/8)
        yourScoreDisplay.fontColor = textColor
        yourScoreDisplay.fontSize = 54
        yourScoreDisplay.zPosition = 1
        
        
        scene.addChild(highScoreDisplay)
        scene.addChild(yourScoreDisplay)
        scene.addChild(playAgain!)
        scene.addChild(endGameBox)
    }
    
    func addRedSquare(view: SKView, scene: SKScene){
            let sprite = SKSpriteNode(color: squareColor, size: CGSize(width: view.frame.size.height/10, height: view.frame.size.height/10))
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            let randXPos = self.getRandXSquare(view: view)
            let randYPos = self.getRandYSquare(view: view)
            sprite.position = CGPoint(x: randXPos, y: randYPos)
            
            var cantSpawn = true
            
            while (cantSpawn)
            {
                cantSpawn = false
                for circle in circles
                {
                    if(sprite.intersects(circle))
                    {
                        let randXPos = self.getRandXSquare(view: view)
                        let randYPos = self.getRandYSquare(view: view)
                        sprite.position =  CGPoint(x: randXPos,y: randYPos)
                        cantSpawn = true
                        break
                    }
                }
            }
        
            squares.append(sprite)
            sprite.physicsBody?.affectedByGravity = false
            scene.addChild(sprite)
        
        if(squares.count >= 30){
            squares[0].removeFromParent()
            squares.remove(at: 0)
        }
    }
    
    func addCircle(view: SKView, scene: SKScene)
    {
        let blueCirc = SKShapeNode(circleOfRadius: view.frame.height/16)
        blueCirc.fillColor = circleColor
        blueCirc.strokeColor = circleColor
        blueCirc.physicsBody = SKPhysicsBody(circleOfRadius: view.frame.height/16)
        let randXPos = self.getRandXBall(view: view)
        let randYPos = self.getRandYBall(view: view)
        blueCirc.position =  CGPoint(x: randXPos,y: randYPos)
        
        var cantSpawn = true
        
        while (cantSpawn)
        {
            cantSpawn = false
            for square in squares
            {
                if(blueCirc.intersects(square))
                {
                    let randXPos = self.getRandXBall(view: view)
                    let randYPos = self.getRandYBall(view: view)
                    blueCirc.position =  CGPoint(x: randXPos,y: randYPos)
                    cantSpawn = true
                    break
                }
            }
        }
        
        circles.append(blueCirc)
        isTouching.append(false)
        touchPoints.append(CGPoint(x: 0, y: 0))
        blueCirc.physicsBody?.affectedByGravity = false
        scene.addChild(blueCirc)
    }
    
    func updateScore(view: SKView, scene: SKScene)
    {
        if(scoreLabel != nil){
            scoreLabel.removeFromParent()}
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = String(self.getScore())
        scoreLabel.fontColor = myTextColor
        scoreLabel.fontSize = 72
        scoreLabel.position = CGPoint(x: 0.0, y: view.frame.height - view.frame.height/4)
        
        scene.addChild(scoreLabel)
    }
    
    func addSwipeToPlay(view: SKView, scene: SKScene)
    {
        swipeToPlayLabel = SKLabelNode(fontNamed: "Arial")
        swipeToPlayLabel.text = "Swipe to play"
        swipeToPlayLabel.fontColor = myTextColor
        swipeToPlayLabel.fontSize = 72
        swipeToPlayLabel.position = CGPoint(x: 0.0, y: 0.0)
        
        scene.addChild(swipeToPlayLabel)

    }
    
    func startSpawning(view: SKView, scene: SKScene){
        let wait = SKAction.wait(forDuration: 1.5)
        let waitBetween = SKAction.wait(forDuration: 0.25)
        let actionMakeCircle = SKAction.run{
            //makeCircleNew()
            self.addCircle(view: view, scene: scene)
        }
        
//        let actionMakeSquare = SKAction.run{
//            if(((self.getScore()%4 == 0) && self.getScore() != 0) || (self.circles.count >= 3 && self.getScore() == 1) || self.circles.count >= 3)
//            {
//                self.addRedSquare(view: view, scene: scene)
//            }
//        }
        
        let actionMakeSquare = SKAction.run{
            self.addRedSquare(view: view, scene: scene)
        }
        
        let squareWait = SKAction.wait(forDuration: TimeInterval(self.getTimeDuration()))
        
        let dummy = SKSpriteNode()
        scene.addChild(dummy)
        
        let dummy2 = SKSpriteNode()
        scene.addChild(dummy2)
        
        dummy.run(SKAction.repeatForever(SKAction.sequence([wait,actionMakeCircle])))
        dummy2.run(SKAction.repeatForever(SKAction.sequence([squareWait, actionMakeSquare])))
    }
    
    func updateHighScore(){
        if let myHighScore:Int = UserDefaults.standard.object(forKey: "HighestScore") as? Int{
            if(myHighScore < self.score){
                UserDefaults.standard.set(self.score, forKey:"HighestScore")
                UserDefaults.standard.synchronize()}
        }
        else{
            UserDefaults.standard.set(self.score, forKey:"HighestScore")
        }
    }
    func goToGameScene(view: SKView, scene: SKScene){
        let gameScene:GameScene = GameScene(size: scene.view!.bounds.size) // create your new scene
        let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.fill
        scene.view!.presentScene(gameScene, transition: transition)
    }
    
}
