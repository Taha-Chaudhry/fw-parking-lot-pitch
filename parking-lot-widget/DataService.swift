//
//  DataService.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 17/08/2023.
//

import Foundation
import SwiftUI
import WidgetKit

struct DataService {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    let logoDictionary: [String: String] = [
        "audi" : "audiImage",
        "bmw" : "bmwImage",
        "cadillac" : "cadillacImage",
        "chevrolet" : "chevroletImage",
        "ferrari" : "ferrariImage",
        "ford" : "fordImage",
        "gmc" : "gmcImage",
        "honda" : "hondaImage",
        "hyundai" : "hyundaiImage",
        "jeep" : "jeepImage",
        "kia" : "kiaImage",
        "lamborghini" : "lamborghiniImage",
        "landrover" : "landroverImage",
        "lexus" : "lexusImage",
        "maserati" : "maseratiImage",
        "mazda" : "mazdaImage",
        "mercedes" : "mercedesImage",
        "mini" : "miniImage",
        "mitsubishi" : "mitsubishiImage",
        "nissan" : "nissanImage",
        "tesla" : "teslaImage",
        "toyota" : "toyotaImage",
        "volkswagen" : "volkswagenImage",
        "volvo" : "volvoImage"
    ]
    
    func getVehicleModel() -> String {
        return vehicleModel
    }
    
    func getIsParked() -> Bool {
        return isParked
    }
    
    func getParkingSpace() -> String {
        return parkingSpace
    }
    
    func getLogo(_ vehicleModel: String) -> AnyView {
        if let logo = logoDictionary.first(where: { vehicleModel.lowercased().contains($0.key) })?.value {
            return AnyView(
                Image(logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    func getUIImageLogo() -> UIImage? {
        if let logo = logoDictionary.first(where: { vehicleModel.lowercased().contains($0.key) })?.value {
            return UIImage(named: logo)
        }
        return nil
    }
}
