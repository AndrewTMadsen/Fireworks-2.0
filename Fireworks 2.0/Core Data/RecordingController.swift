//
//  RecordingController.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 8/23/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RecordingController {
    
    static let sharedController = RecordingController()
    var startTime: Date?
    var endTime: Date?
    var fireworks: [Firework] = Array<Firework>()
    
    var recordings: [Recording] {
        let request: NSFetchRequest<Recording> = Recording.fetchRequest()
        
        do {
            return try Stack.context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func saveRecording(_ sender: GameViewController) {
        guard let startTime = startTime, let endTime = endTime else {
            return
        }
        var recordingName: String = "Unnamed-\(Date())"
        let alert = UIAlertController(title: "Give your new Recording a Name", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in textField.placeholder = "Name of the recording"})
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                recordingName = name
            }
            let recording = Recording(name: recordingName, startTime: startTime, endTime: endTime, fireworks: self.fireworks)
            print(recording!.name)
            do {
                try Stack.context.save()
            } catch {
                print("Could not save recordings to core data")
            }
        }))
        alert.addAction(UIAlertAction(title: "Discard Recording", style: .destructive, handler: nil))
        sender.present(alert, animated: true)
    }
    
    func deleteRecordings (recordings: Recording) {
        Stack.context.delete(recordings)
        do {
            try Stack.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
