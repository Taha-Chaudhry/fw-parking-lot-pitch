//
//  ContentView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 16/08/2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if vehicleModel == "" {
                    StartingView()
                } else {
                    UnparkedView()
                }
            }
        }
        .onOpenURL { incomingURL in
            handleIncomingURL(incomingURL)
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "parkingapp" else {
            return
        }

        if url.host == "unpark" {
            unpark()
        }
        
        return
    }
    
    public func unpark() {
        isParked = false
        parkingSpace = ""
        WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
        UnparkedView().stopActivity()
    }
}

func isBlank(_ string: String) -> Bool {
  for character in string {
    if !character.isWhitespace {
        return false
    }
  }
  return true
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
