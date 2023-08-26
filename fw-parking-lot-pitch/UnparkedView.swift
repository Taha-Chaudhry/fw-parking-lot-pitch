//
//  UnparkedView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import ActivityKit
import SwiftUI
import WidgetKit
import OSLog

struct UnparkedView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var parkingSpace: String = ""
    @AppStorage("isEVSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isEVSpace: Bool = false
    @AppStorage("isCharging", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isCharging: Bool = false
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var name: String = ""
    @AppStorage("licensePlate", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var licensePlate: String = ""
    
    @State private var isEditingVehicleModel = false
    
    var body: some View {
        VStack {
            HStack {
                Text("\($vehicleModel.wrappedValue)")
                    .font(.largeTitle)
                    .bold()
                DataService().getLogo(vehicleModel)
                    .frame(width: 35, height: 35)
            }.padding()
            
//            Text("Tap on the space you would like to park at")
//                .fontDesign(.rounded)
//                .bold()
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
            
            Divider()

//            Spacer()
//            Spacer()
            
            Text("We kindly ask you to park your vehicle to proceed. Thank you for your cooperation")
                .fontDesign(.rounded)
                .bold()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()
            
//            VStack {
//                ForEach(0..<5) { row in
//                    HStack {
//                        let leftPreview = "\(Character(UnicodeScalar(row + 65)!))"
//                        Text("").padding()
//                        VStack {
//                            if row == 0 {
//                                Spacer()
//                                    .frame(width: 40, height: 40)
//                            }
//                            Text("\(leftPreview)")
//                                .frame(width: 40, height: 40)
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.center)
//                                .edgesIgnoringSafeArea(.bottom)
//                        }
//
//                        ForEach(1..<5) { column in
//                            ParkingGrid(isParked: isParked, parkingSpace: parkingSpace, activity: activity, row: row, column: column)
//                        }.padding()
//
//                        Text("")
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.gray)
//                            .multilineTextAlignment(.center)
//                            .edgesIgnoringSafeArea(.bottom)
//                    }
//                }.padding()
//            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditingVehicleModel.toggle()
                }) {
                    Label("Edit", systemImage: "pencil")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    name = ""
                    vehicleModel = ""
                    licensePlate = ""
                }) {
                    Label("Reset", systemImage: "exclamationmark.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $isEditingVehicleModel) {
            EditProfileView(isEditing: $isEditingVehicleModel)
        }
    }
    
    func startActivity() throws {
        let activityAttributes = ParkingAttributes(vehicleModel: vehicleModel, parkingSpace: parkingSpace)
        let activityState = ParkingAttributes.ContentState(isEVSpace: isEVSpace, isCharging: isCharging)

        let activityContent = ActivityContent(state: activityState, staleDate: nil)

        do {
            let activity = try Activity<ParkingAttributes>.request(attributes: activityAttributes, content: activityContent, pushType: .token)
        } catch(let error) {
            print("Eror starting activity: \(error)")
        }
    }
    
    func updateActivity(isCharging: Bool) {
        let updatedChargingState = Activity<ParkingAttributes>.ContentState(isEVSpace: isEVSpace, isCharging: isCharging)
        let updatedContent = ActivityContent(state: updatedChargingState, staleDate: nil)
        
        let alertConfiguration = AlertConfiguration(title: isCharging ? "\(vehicleModel) now charging ⚡️" : "\(vehicleModel) no longer charging", body: "At space \(parkingSpace)", sound: .default)
        
        Task {
            for activity in Activity<ParkingAttributes>.activities {
                await activity.update(updatedContent, alertConfiguration: alertConfiguration)
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
        }
    }
    
    func stopActivity() {
        let state = ParkingAttributes.ContentState(isEVSpace: isEVSpace, isCharging: isCharging)

        let finalContent = ActivityContent(state: state, staleDate: nil)

        Task {
            for activity in Activity<ParkingAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
            }
        }
    }
}
 
