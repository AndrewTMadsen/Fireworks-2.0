//
//  GameScene.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 7/11/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var hasSetSize = false
    var particles = [UITouch: SKEmitterNode]()
    var particleTrails = [UITouch: SKEmitterNode]()
    var boomPlayer: [AVAudioPlayer] = []
    var countdownTimer: Timer!
    var delayTime = 0.125
    var isTouchEligible = true
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: delayTime, target: self, selector: #selector(endTimer), userInfo: nil, repeats: true)
        isTouchEligible = false
    }

    @objc func endTimer() {
        countdownTimer.invalidate()
        isTouchEligible = true
    }
    
    //MARK: Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchEligible {
            startTail(at: touches) { point in
                self.fireFirework(point)
                self.playBoomSound()
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchEligible {
            startTail(at: touches) { point in
                self.fireFirework(point)
                self.playBoomSound()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
    }
    
    func removeTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            particles[touch] = nil
        }
    }
    
    //MARK: Fireworks
    
    var booms: [SKEmitterNode] = [SKEmitterNode(fileNamed: "FireworkExplosion")!, SKEmitterNode(fileNamed: "FireworkExplosion2")!, SKEmitterNode(fileNamed:"FireworkExplosion3")!, SKEmitterNode(fileNamed: "FireworkExplosion4")!, SKEmitterNode(fileNamed: "FireWorkAN")!, SKEmitterNode(fileNamed: "FireworkRL")!, SKEmitterNode(fileNamed: "FireworkKA")!, SKEmitterNode(fileNamed: "FireworkCA")!, SKEmitterNode(fileNamed: "FireworkAB")!, SKEmitterNode(fileNamed: "FireworkSM")!, SKEmitterNode(fileNamed: "FireworkBM")!]
   
    
//    func fireFirework(at touches: Set<UITouch>) {
//        for touch in touches {
//            if let particle = getParticle(touch) {
//
//                let point = touch.preciseLocation(in: touch.view)
//                particle.position = CGPoint(x: point.x, y: -point.y)
//                self.addChild(particle)
//            } else {
//                print("No Particle Found")
//            }
//        }
//    }
    
    func playBoomSound() {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Firework Sound.mp3", ofType: nil)!)
        do {
            var boomSound: AVAudioPlayer? = try AVAudioPlayer(contentsOf: url)
            boomSound?.delegate = self
            boomPlayer.append(boomSound!)
            boomSound!.play()
            boomSound = nil
        } catch {
            print(error)
            print(error.localizedDescription)
            print("Could Not Load File")
        }
    }
    
    func fireFirework(_ point: CGPoint) {
        let randomNumber = Int(arc4random_uniform(UInt32(booms.count)))
        if let particle = self.booms[randomNumber].copy() as? SKEmitterNode {
            particle.run(SKAction.sequence([SKAction.wait(forDuration: 1.25), SKAction.removeFromParent()]))
                particle.position = point
                self.addChild(particle)
            } else {
                print("No Particle Found")
            }

    }
    
    func getParticle(_ touch: UITouch) -> SKEmitterNode? {
        if let particle = particles[touch] {
            let smth = particle.copy() as? SKEmitterNode
            smth?.run(SKAction.sequence([SKAction.wait(forDuration: 1.25), SKAction.removeFromParent()]))
            return smth
        } else {
            let randomNumber = Int(arc4random_uniform(UInt32(booms.count)))
            if let particle = self.booms[randomNumber].copy() as? SKEmitterNode {
                particles[touch] = particle
                particle.run(SKAction.sequence([SKAction.wait(forDuration: 1.25), SKAction.removeFromParent()]))
                return particle
            } else {
                return nil
            }
        }
    }
    
    //MARK: Firework Trails
    var boomTrails: [SKEmitterNode] = [SKEmitterNode(fileNamed: "testTrail")!, SKEmitterNode(fileNamed: "Trail0")!, SKEmitterNode(fileNamed: "Trail1")!, SKEmitterNode(fileNamed: "Trail2")!,SKEmitterNode(fileNamed: "Trail3")!, SKEmitterNode(fileNamed: "Trail4")!, SKEmitterNode(fileNamed: "TrailGOD")!, SKEmitterNode(fileNamed: "Trail5")!, SKEmitterNode(fileNamed: "Trail9")!,SKEmitterNode(fileNamed: "Trail10")!, SKEmitterNode(fileNamed: "Trail11")!]
    
    func startTail(at touches: Set<UITouch>, _ completion: @escaping (_ point: CGPoint) -> Void) {
        for touch   in touches {
            let oldPoint = touch.preciseLocation(in: self.view)
            let newPoint = CGPoint(x: oldPoint.x, y: -oldPoint.y)
        if let particleTrail = particleTrails[touch] {
            
            if let smthT = particleTrail.copy() as? SKEmitterNode {
            smthT.run(SKAction.sequence([SKAction.move(to: newPoint, duration: TimeInterval(1.0 * (UIScreen.main.bounds.height - oldPoint.y) / UIScreen.main.bounds.height)), SKAction.removeFromParent(), SKAction.run {completion(newPoint)}]))
                smthT.position = CGPoint(x: oldPoint.x, y: -UIScreen.main.bounds.height)
            self.addChild(smthT)
            }
        } else {
            let randomNumber = Int(arc4random_uniform(UInt32(boomTrails.count)))
            if let particleTrail = self.boomTrails[randomNumber].copy() as? SKEmitterNode {
                particleTrails[touch] = particleTrail
                particleTrail.run(SKAction.sequence([SKAction.move(to: newPoint, duration: TimeInterval(1.0 * (UIScreen.main.bounds.height - oldPoint.y) / UIScreen.main.bounds.height)), SKAction.removeFromParent(), SKAction.run {completion(newPoint)}]))
                particleTrail.position = CGPoint(x: oldPoint.x, y: -UIScreen.main.bounds.height)
                self.addChild(particleTrail)
            }
        }
        }
        startTimer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !hasSetSize {
            self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view?.shouldCullNonVisibleNodes = true
            hasSetSize = true
        }
    }
}

extension GameScene: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let index = boomPlayer.index(of: player) else {
            return
        }
        boomPlayer.remove(at: index)
    }
}


