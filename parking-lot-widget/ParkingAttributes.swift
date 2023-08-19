//
//  ParkingAttributes.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import SwiftUI
import ActivityKit

struct ParkingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startDate: Date
    }
    
    var vehicleModel: String
    var parkingSpace: String
}
