//
//  GameScene.swift
//  sexEd
//
//  Created by Chennasri Kaveti on 2/18/17.
//  Copyright © 2017 Chennasri Kaveti. All rights reserved.
//
import SpriteKit
import GameplayKit

struct PhysicsCategory
{
    static let player : UInt32 = 0x1 << 1
    static let  border1 : UInt32 = 0x1 << 1
    static let  border2 : UInt32 = 0x1 << 1
    static let chlamydia: UInt32 = 0x1 << 1
    static let crab: UInt32 = 0x1 << 1
}
class GameScene: SKScene
{
    
    let player = SKSpriteNode(imageNamed: "User")
    let border1 = SKSpriteNode(imageNamed: "border")
    let border2 = SKSpriteNode(imageNamed: "border")
    let screenSize: CGRect = UIScreen.main.bounds
    var touchingScreen = false
    var yVelocity: CGFloat = -200
    
    let main1 = SKSpriteNode(imageNamed: "Begin Screen")

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addCrabs() {
        
        // Create sprite
        let crab = SKSpriteNode(imageNamed: "Crabs2")
        
        crab.setScale(2)
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: -(size.height/2) + (crab.size.height), max: (size.height/2) - (crab.size.height))
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        crab.position = CGPoint(x: size.width + crab.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(crab)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -(size.width/2)-crab.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        crab.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func addChlam() {
        
        // Create sprite
        let chlamydia = SKSpriteNode(imageNamed: "Chlamydia")
        
        chlamydia.setScale(2)
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: -(size.height/2) + (chlamydia.size.height), max: (size.height/2) - (chlamydia.size.height))
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        chlamydia.position = CGPoint(x: size.width + chlamydia.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(chlamydia)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -(size.width/2)-chlamydia.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        chlamydia.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }

    override func didMove(to view: SKView)
    {
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.position = CGPoint(x: (-screenSize.size.width/2 * 0.9), y: 0)
        border1.position = CGPoint(x:0, y: screenSize.size.height/2)
        border1.physicsBody = SKPhysicsBody(rectangleOf: border1.size)
        border1.physicsBody?.categoryBitMask = PhysicsCategory.border1
        border1.physicsBody?.categoryBitMask = PhysicsCategory.player
        border1.physicsBody?.affectedByGravity = false
        border1.physicsBody?.isDynamic = false
        border2.position = CGPoint(x:0, y: -screenSize.size.height/2)
        border2.physicsBody = SKPhysicsBody(rectangleOf: border2.size)
        border2.physicsBody?.categoryBitMask = PhysicsCategory.border2
        border2.physicsBody?.categoryBitMask = PhysicsCategory.player
        border2.physicsBody?.affectedByGravity = false
        border2.physicsBody?.isDynamic = false
//        player.physicsBody = SKPhysicsBody (circleOfRadius: player.frame.height / 2)
//        player.physicsBody?.categoryBitMask = PhysicsCategory.player
//        player.physicsBody?.collisionBitMask = PhysicsCategory.crab
//        player.physicsBody?.contactTestBitMask = PhysicsCategory.crab
//        player.physicsBody?.collisionBitMask = PhysicsCategory.chlamydia
//        player.physicsBody?.contactTestBitMask = PhysicsCategory.chlamydia
        player.physicsBody?.isDynamic = true
        self.addChild (player)
        player.setScale(2.5)
        addChild(border2)
        addChild(border1)
        addChild(player)
        print(self.frame.height)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addCrabs),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addChlam),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print(player.position.y)
        _ = touches.first
        if (player.position.y <= self.frame.height)
        {
            yVelocity = 200
        }
        else
        {
            yVelocity = 0
        }
        touchingScreen = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        if (player.position.y > -self.frame.height)
        {
            yVelocity = -200
        }
        else
        {
            yVelocity = 0
        }
        touchingScreen = false
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        let rate: CGFloat = 0.5; //Controls rate of motion. 1.0 instantaneous, 0.0 none.
        let relativeVelocity: CGVector = CGVector(dx: 0 , dy:yVelocity-player.physicsBody!.velocity.dy);
        player.physicsBody?.velocity=CGVector(dx: 0, dy: (player.physicsBody?.velocity.dy)!+relativeVelocity.dy*rate)
        }
    }

    // Popup boxes that come up upon collision


//    // Function that shows dialogue box
//func showBox(_ info: CGImage)
//    {
//        _.anchorPoint = CGPointMake(0.5, 0.5)
//        _.size.height = self.size.height
//        _.position = CGPointMake(CGRectGetMidX(self, frame), CRectGetMidY(self.frame))
//        
//        self.addChild(info)
//    }













