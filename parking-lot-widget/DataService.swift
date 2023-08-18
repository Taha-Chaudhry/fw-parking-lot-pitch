//
//  DataService.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 17/08/2023.
//

import Foundation
import SwiftUI

struct DataService {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
//    func unpark() -> String {
//        return ""
//    }
    
    func getVehicleModel() -> String {
        return vehicleModel
    }
    
    func getIsParked() -> Bool {
        return isParked
    }
    
    func getParkingSpace() -> String {
        return parkingSpace
    }
}
