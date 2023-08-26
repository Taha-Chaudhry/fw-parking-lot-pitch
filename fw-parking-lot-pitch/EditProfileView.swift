//
//  EditVehicleModelView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import SwiftUI

struct EditProfileView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var vehicleModelStorage: String = ""
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var nameStorage: String = ""
    @AppStorage("licensePlate", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var licensePlateStorage: String = ""
    @Binding var isEditing: Bool
    
    @State private var vehicleModel: String = ""
    @State private var name: String = ""
    @State private var licensePlate: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Name", text: $name)
                TextField("Enter Vehicle Model", text: $vehicleModel)
                TextField("Enter License Plate", text: $licensePlate)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        $vehicleModelStorage.wrappedValue = $vehicleModel.wrappedValue
                        $nameStorage.wrappedValue = $name.wrappedValue
                        $licensePlateStorage.wrappedValue = $licensePlate.wrappedValue
                        isEditing.toggle()
                    }) {
                        Text("Done")
                    }.disabled(((name == "" || isBlank(name)) || (vehicleModel == "" || isBlank(vehicleModel)) || (licensePlate == "" || isBlank(licensePlate))))
                }
            }
            .interactiveDismissDisabled()
            .navigationTitle("Edit Vehicle Model")
        }
    }
}
