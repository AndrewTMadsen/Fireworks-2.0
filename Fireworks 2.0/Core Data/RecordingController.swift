//
//  RecordingController.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 8/23/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import Foundation
import CoreData

class RecordingController {
    
    static let sharedController = RecordingController()
    
    var recordings: [Recording] {
        
        let request: NSFetchRequest<Recording> = Recording.fetchRequest()
        
        do {
            return try Stack.context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func createRecording(hasTrails: Bool, instrument: Int16) {
        let _ = Recording(hasTrails: hasTrails , instrument: instrument)
        saveRecording()
    }
    
    func saveRecording() {
        do {
            try Stack.context.save()
        } catch {
            print("Could not save recordings to core data")
        }
    }
    
    func deleteRecordings (recordings: Recording) {
        Stack.context.delete(recordings)
        saveRecording()
    }
    
}
