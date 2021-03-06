//
//  GameViewController.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 7/11/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import ReplayKit

class GameViewController: UIViewController, RPPreviewViewControllerDelegate, RecorderDelegate {
    
    var startTime: TimeInterval = 0
    var timeKeep: [TimeInterval: CGPoint] = [:]
    let recorder = RPScreenRecorder.shared()
    var hasTrails: Bool = false
    private var isRecording = false
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var instrumentStackView: UIStackView!
    
    @IBAction func viewRecordings(_ sender: UIButton) {
        performSegue(withIdentifier: "viewWithListOfRecordings", sender: nil)
    }
    
    @IBAction func toggleRecording(_ sender: UIButton) {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
        sender.setTitle(isRecording ? "End Recording" : "Start Recording", for: .normal)
    }
    
    @IBAction func toggleSettingsView(_ sender: UIButton) {
        let xDevices: [CGFloat] = [1792 /*XR*/, 2436 /*X, XS*/, 2688 /*XS Max*/]
        UIView.animate(withDuration: 0.3) {
            self.settingsView.transform = self.settingsView.transform == CGAffineTransform.identity ? CGAffineTransform(translationX: 0, y: -self.settingsView.bounds.height - (UIDevice().userInterfaceIdiom == .phone && xDevices.contains(UIScreen.main.nativeBounds.height) ? 35 : 0)) : CGAffineTransform.identity
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                GameScene.sharedInstance = scene
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        instrumentStackView.translatesAutoresizingMaskIntoConstraints = false
        for instrument in GameScene.sharedInstance.instrumentTypes.keys {
            let instrumentButton = UIButton()
            instrumentButton.setTitle("\(instrument)".titlecased(), for: .normal)
            instrumentButton.setTitleColor(UIColor(red: 0, green: 122.0 / 255, blue: 1, alpha: 1), for: .normal)
            instrumentButton.setTitleColor(UIColor(red: 207.0 / 255, green: 230.0 / 255, blue: 1, alpha: 1), for: .highlighted)
            instrumentButton.addTarget(self, action: #selector(instrumentButtonTapped), for: .touchUpInside)
            instrumentStackView.addArrangedSubview(instrumentButton)
        }
        
        let trailsButton = UIButton()
        trailsButton.setTitle("Trails", for: .normal)
        trailsButton.setTitleColor(UIColor(red: 0, green: 122.0 / 255, blue: 1, alpha: 1), for: .normal)
        trailsButton.setTitleColor(UIColor(red: 207.0 / 255, green: 230.0 / 255, blue: 1, alpha: 1), for: .highlighted)
        trailsButton.addTarget(self, action: #selector(instrumentButtonTapped), for: .touchUpInside)
        //Thank you for providing me with the default color values in your enum Swift, I really appreciate it!
        instrumentStackView.addArrangedSubview(trailsButton)
    }
    
    func fireworkHasFired(point: CGPoint) {
        if isRecording {
            timeKeep[NSDate.timeIntervalSinceReferenceDate - startTime] = point
        }
        
    }
    
    func startRecording() {
        RecordingController.sharedController.startTime = Date()
        self.isRecording = true
    }
    
    func stopRecording() {
        RecordingController.sharedController.endTime = Date()
        self.isRecording = false
        RecordingController.sharedController.saveRecording(self)
        RecordingController.sharedController.startTime = nil
        RecordingController.sharedController.endTime = nil
        RecordingController.sharedController.fireworks = []
        /*
         for (thing, thing) in dictionary
         {  
            //put into coredata
         }
         */
    }
    
 
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }
    
    @objc func instrumentButtonTapped(_ sender: UIButton){
        var selectedSound: Instrument?
        if sender.title(for: .normal) == "Trails" {
            GameScene.sharedInstance.trailsEnabled = true
        } else {
            GameScene.sharedInstance.trailsEnabled = false
            for instrument in GameScene.sharedInstance.instrumentTypes.keys {
                if sender.title(for: .normal)!.lowercased() == "\(instrument)" {
                    selectedSound = instrument
                    break
                }
            }
        }
        
        if let sound = selectedSound {
            GameScene.sharedInstance.currentInstrument = sound
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    var style: UIStatusBarStyle = .lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return self.style
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
