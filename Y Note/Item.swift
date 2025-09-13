//
//  Item.swift
//  Y Note
//
//  Created by Chitose on 9/13/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
