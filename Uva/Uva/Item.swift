//
//  Item.swift
//  Uva
//
//  Created by César de Souza on 16/04/24.
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
