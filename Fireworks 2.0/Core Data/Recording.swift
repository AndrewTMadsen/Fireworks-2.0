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
    convenience init?(hasTrails: Bool, instrument: Int16) {
        self.init(context: Stack.context)
        
        self.hasTrails = hasTrails
        self.instrument = instrument
    }
    
}
