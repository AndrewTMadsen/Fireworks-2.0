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

    static var sharedInstance: GameScene!
    var hasSetSize = false
    var particles = [UITouch: SKEmitterNode]()
    var particleTrails = [UITouch: SKEmitterNode]()
    var boomPlayer: [AVAudioPlayer] = []
    var countdownTimer: Timer?
    var delayTime = 0.3
    let instrumentTypes: [Instrument: Int] = [.piano: 8, .guitar: 6]
    var currentInstrument = Instrument.piano
    var trailsEnabled = false
    var isTouchValid = true
    var booms: [SKEmitterNode] = [SKEmitterNode(fileNamed: "FireworkExplosion")!, SKEmitterNode(fileNamed: "FireworkExplosion2")!, SKEmitterNode(fileNamed:"FireworkExplosion3")!, SKEmitterNode(fileNamed: "FireworkExplosion4")!, SKEmitterNode(fileNamed: "FireWorkAN")!, SKEmitterNode(fileNamed: "FireworkRL")!, SKEmitterNode(fileNamed: "FireworkKA")!, SKEmitterNode(fileNamed: "FireworkCA")!, SKEmitterNode(fileNamed: "FireworkAB")!, SKEmitterNode(fileNamed: "FireworkSM")!, SKEmitterNode(fileNamed: "FireworkBM")!]
    
    var boomTrails: [SKEmitterNode] = [SKEmitterNode(fileNamed: "testTrail")!, SKEmitterNode(fileNamed: "Trail0")!, SKEmitterNode(fileNamed: "Trail1")!, SKEmitterNode(fileNamed: "Trail2")!,SKEmitterNode(fileNamed: "Trail3")!, SKEmitterNode(fileNamed: "Trail4")!, SKEmitterNode(fileNamed: "TrailGOD")!, SKEmitterNode(fileNamed: "Trail5")!, SKEmitterNode(fileNamed: "Trail9")!,SKEmitterNode(fileNamed: "Trail10")!, SKEmitterNode(fileNamed: "Trail11")!]
    
    weak var recDelegate: RecorderDelegate?
    
    //MARK: Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        runTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        runTouch(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
        endTimer()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
        endTimer()
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: delayTime, target: self, selector: #selector(endTimer), userInfo: nil, repeats: true)
    }
    
    @objc func endTimer() {
        if countdownTimer != nil
        {
            self.countdownTimer?.invalidate()
            self.countdownTimer = nil
        }
    }
    
    func runTouch(_ touches: Set<UITouch>) {
        if countdownTimer == nil && isTouchValid {
            startTimer()
            //startTail(at: touches) { point in //NON MUSIC MODE
            if RecordingController.sharedController.startTime != nil {
                for point in touches {
                    FireworkController.sharedController.createFirework(time: Int64(Date().timeIntervalSinceReferenceDate - RecordingController.sharedController.startTime!.timeIntervalSinceReferenceDate), x: Double(point.preciseLocation(in: view).x), y: Double(point.preciseLocation(in: view).y), instrument: trailsEnabled ? "Trails" : "\(currentInstrument)".titlecased())
                }
            }
            if trailsEnabled {
                isTouchValid = false
                startTail(at: touches) { point in
                    self.fireFirework(point) //If not music, pass in just point here.
                    var section = 0
                    var currentSize = UIScreen.main.bounds.height / CGFloat(self.instrumentTypes[self.currentInstrument]!)
                    while(currentSize < -point.y) { //If not music, pass in just -point.y here.
                        currentSize += UIScreen.main.bounds.height / CGFloat(self.instrumentTypes[self.currentInstrument]!)
                        section += 1 //Thanks swift ++ is so hard
                    }
                    self.playBoomSound("Firework Sound")
                    self.isTouchValid = true
                }
            } else {
                for point in touches {
                    fireFirework(CGPoint(x: point.preciseLocation(in: view).x, y: -point.preciseLocation(in: view).y)) //If not music, pass in just point here.
                    var section = 0
                    var currentSize = UIScreen.main.bounds.height / CGFloat(instrumentTypes[currentInstrument]!)
                    while(currentSize < point.preciseLocation(in: view).y) { //If not music, pass in just -point.y here.
                        currentSize += UIScreen.main.bounds.height / CGFloat(instrumentTypes[currentInstrument]!)
                        section += 1 //Thanks swift ++ is so hard
                    }
                     playBoomSound("\("\(currentInstrument)".titlecased())_\(section)")
                }
            }
        }
    }
    
    func removeTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            particles[touch] = nil
        }
    }
    
    // Mark: Firework Particle
    func fireFirework(_ point: CGPoint) {
        recDelegate?.fireworkHasFired(point: point)
        let randomNumber = Int(arc4random_uniform(UInt32(booms.count)))
        if let particle = self.booms[randomNumber].copy() as? SKEmitterNode {
            particle.run(SKAction.sequence([SKAction.wait(forDuration: 1.25), SKAction.removeFromParent()]))
            particle.position = point
            self.addChild(particle)
        }
        //send data to gameviewController
    }
    
    func playBoomSound(_ fileName: String) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "\(fileName).mp3", ofType: nil)!)
        do {
            var boomSound: AVAudioPlayer? = try AVAudioPlayer(contentsOf: url)
            boomSound?.delegate = self
            boomPlayer.append(boomSound!)
            boomSound!.play()
            boomSound = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getParticle(_ touch: UITouch) -> SKEmitterNode? {
        if let particle = particles[touch] {
            //TODO: Change my name. SMTH SMH that's atrocious
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
    func startTail(at touches: Set<UITouch>, _ completion: @escaping (_ point: CGPoint) -> Void) {
        for touch in touches {
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

enum Instrument: Int {
    case piano = 0
    case guitar = 1
}

protocol RecorderDelegate: class {
    func fireworkHasFired(point: CGPoint)
}

extension String {
    func titlecased() -> String {
        var newString = ""
        for word in self.split(separator: " ") {
            newString += "\(String(word.first!).uppercased())\(word.dropFirst().lowercased())"
        }
        return newString
    }
}
