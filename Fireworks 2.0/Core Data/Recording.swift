//
//  Recording.swift
//  Fireworks 2.0
//
//  Created by Andrew Madsen on 8/23/18.
//  Copyright © 2018 Andrew Madsen. All rights reserved.
//

import Foundation
import CoreData

extension Recording {
    convenience init?(name: String, startTime: Date, endTime: Date, fireworks: [Firework]) {
        self.init(context: Stack.context)
        
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.cams = NSSet(array: fireworks)
    }
}
