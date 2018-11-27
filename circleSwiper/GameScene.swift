import SpriteKit
import Darwin

var playAgain: SKSpriteNode?

class GameScene: SKScene {

    var dummy: SKSpriteNode!
    var wait: SKAction!
    var touchPoint: CGPoint = CGPoint()
    
 
    var squareColor: UIColor = UIColor(red: 243.0/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1.0)
    var circleColor: UIColor = UIColor(red: 149/255.0, green: 225/255.0, blue: 211/255.0, alpha: 1.0)
    var background: UIColor = UIColor.white
    var myTextColor: UIColor = UIColor(red: 84/255.0, green: 75/255.0, blue: 61/255.0, alpha: 1.0)
    
    var brain = mainModel()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = background
        
        self.brain.addSwipeToPlay(view: self.view!, scene: self)
        
        brain.updateScore(view: self.view!, scene: self)
     
        self.brain.addRedSquare(view: self.view!, scene: self)
        
        self.brain.addCircle(view: self.view!, scene: self)
        
        self.physicsBody = SKPhysicsBody()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if(brain.swipeToPlayExists(scene: self)){
            brain.removeSwipeToPlay()
            brain.startSpawning(view: self.view!, scene: self)
            print(1)
        }

        let touch = touches.first as! UITouch
        let location = touch.location(in: self)

        var i = 0
        for circle in brain.circles{
            if circle.frame.contains(location) {
            brain.touchPoints[i] = location
            brain.isTouching[i] = true
            }
            i += 1
        }
        if(playAgain != nil)
        {
            if(playAgain!.frame.contains(location)){
                playAgain = nil
                self.removeAllChildren()
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                newScene.anchorPoint = self.anchorPoint
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
        }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        
        var i = 0
        for circle in brain.circles{
        let location = touch.location(in: self)
        brain.touchPoints[i] = location
            i += 1
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var i = 0
        for circle in brain.circles{
            brain.isTouching[i] = false
            i += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var i = 0
        for circle in brain.circles{
        if  brain.isTouching[i] {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: brain.touchPoints[i].x-circle.position.x, dy: brain.touchPoints[i].y-circle.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            circle.physicsBody!.velocity=velocity
        }
            i += 1
        }
        i = 0
        for circle in brain.circles{ 
            if((abs(circle.position.x) > frame.width/2) || (abs(circle.position.y) > frame.height/2))
            {
                brain.circles.remove(at: i)
                brain.isTouching.remove(at: i)
                brain.touchPoints.remove(at: i)
                circle.removeFromParent()
                brain.increment()
                brain.updateScore(view: self.view!, scene: self)
            }
            i += 1
            for square in brain.squares{
                if(circle.intersects(square))
                {
                self.isPaused = true
                brain.updateHighScore()
                brain.endGame(view: self.view!, scene: self, textColor: myTextColor)
                }
            }
    }
    }
}

