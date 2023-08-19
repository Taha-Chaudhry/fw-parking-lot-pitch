//
//  EditVehicleModelView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import SwiftUI

struct EditVehicleModelView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModelStorage: String = ""
    @Binding var isEditing: Bool
    
    @State private var vehicleModel: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Vehicle Model \($vehicleModel.wrappedValue)", text: $vehicleModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        $vehicleModelStorage.wrappedValue = $vehicleModel.wrappedValue
                        isEditing.toggle()
                    }) {
                        Text("Done")
                    }.disabled(vehicleModel == "" || isBlank(vehicleModel))
                }
            }
            .interactiveDismissDisabled()
            .navigationTitle("Edit Vehicle Model")
        }
    }
}
