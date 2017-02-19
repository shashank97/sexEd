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
}

class GameScene: SKScene
{
    let player = SKSpriteNode(imageNamed: "User")
    let border1 = SKSpriteNode(imageNamed: "border")
    let border2 = SKSpriteNode(imageNamed: "border")
    let screenSize: CGRect = UIScreen.main.bounds
    var touchingScreen = false
    var yVelocity: CGFloat = -200
    
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
        player.setScale(2)
        addChild(border2)
        addChild(border1)
        addChild(player)
        print(self.frame.height)
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        for t in touches
//        {
//            self.touchUp(atPoint: t.location(in: self))
//        }
    }
    
    
    override func update(_ currentTime: CFTimeInterval) {
        let rate: CGFloat = 0.5; //Controls rate of motion. 1.0 instantaneous, 0.0 none.
        let relativeVelocity: CGVector = CGVector(dx: 0 , dy:yVelocity-player.physicsBody!.velocity.dy);
        player.physicsBody?.velocity=CGVector(dx: 0, dy: (player.physicsBody?.velocity.dy)!+relativeVelocity.dy*rate)
        }
    }
