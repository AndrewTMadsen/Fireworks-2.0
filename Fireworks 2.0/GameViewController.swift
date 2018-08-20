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
    private var isRecording = false
    
    func fireworkHasFired(point: CGPoint) {
        if isRecording {
            timeKeep[NSDate.timeIntervalSinceReferenceDate - startTime] = point
        }
        
    }
    
    func startRecording() {
        startTime = NSDate.timeIntervalSinceReferenceDate
        self.isRecording = true
    }
    
    
    func stopRecording() {
    startTime = 0
    self.isRecording = false
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
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var instrumentStackView: UIStackView!
    var hasTrails: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                GameScene.sharedInstance = scene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
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
    
    @IBAction func toggleSettingsView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.settingsView.transform = self.settingsView.transform == CGAffineTransform.identity ? CGAffineTransform(translationX: 0, y: -self.settingsView.bounds.height - (UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 ? 35 : 0)) : CGAffineTransform.identity
        }
    }
    
    @objc func instrumentButtonTapped(_ sender: UIButton)
    {
        if sender.title(for: .normal) == "Trails" {
            //Set things to trails
        }
        else {
            for instrument in GameScene.sharedInstance.instrumentTypes.keys {
                if sender.title(for: .normal)!.lowercased() == "\(instrument)" {
                    //Set things to that instrument
                    break
                }
            }
        }
    }
    
    @IBAction func trailsSwitched(_ sender: UISwitch) {
        hasTrails = sender.isOn
    }
    
    @IBAction func toggleRecording(_ sender: UIButton) {
        isRecording = !isRecording
        sender.setTitle(isRecording ? "End Recording" : "Start Recording", for: .normal)
    }
    
    @IBAction func viewRecordings(_ sender: UIButton) {
        performSegue(withIdentifier: "viewWithListOfRecordings", sender: nil)
    }
    
    /*(func handleMore() {
        settingsLauncher.present(settingsLauncher, animated: true, completion: nil)
    }*/
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
