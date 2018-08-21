//
//  FireworkController.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 8/9/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import Foundation
import CoreData

class FireworkController {
    static let sharedController = FireworkController()
    
    var fireworks: [Firework] {
        let request: NSFetchRequest<Firework> = Firework.fetchRequest()
        
        do {
            return try Stack.context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
   
    func save() {
        do {
            try Stack.context.save()
        } catch {
            print("Cant save to core data")
        }
    }
    
    func delete(Firework: Firework) {
        Stack.context.delete(Firework)
        save()
    }
    
    func createFirework(time: Int64, x: Double, y: Double) {
       let _ = Firework(time: time, x: x, y: y)
        save()
    }
}
