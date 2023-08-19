//
//  ParkingGrid.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ParkingGrid: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    var activity: Activity<ParkingAttributes>?
    var row: Int
    var column: Int
    
    
    var body: some View {
        VStack {
            if row == 0 {
                Text("\(column)")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            
            let letter = Character(UnicodeScalar(row + 65)!)
            let parkingSpace = "\(letter)\(column)"
            
            Button {
                withAnimation {
                    isParked = true
                    $parkingSpace.wrappedValue = parkingSpace
                    WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                }
                UnparkedView().startActivity()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.black)
            }
        }
    }
}
