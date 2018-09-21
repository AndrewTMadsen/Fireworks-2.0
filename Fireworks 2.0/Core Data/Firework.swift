//
//  Firework.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 8/9/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import Foundation
import CoreData

extension Firework {
    convenience init?(time: Int64, x: Double, y: Double, instrument: String, context: NSManagedObjectContext = Stack.context) {
        self.init(context: Stack.context)
        
        self.instrument = instrument
        self.time = time
        self.x = x
        self.y = y
    }
}
