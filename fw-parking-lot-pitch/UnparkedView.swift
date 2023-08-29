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
            
//            Divider()
            Image("UnparkedImage")
                .resizable()
                .scaledToFit()
                .frame(width: 550, height: 400)
                .padding(.top)
                .padding(.top)
            
            VStack {
                Text("You are currently not parked")
//                    .padding(.bottom)
                Text("Once you reach your parking space you will be notified")
//                    .padding(.top)
            }
            .fontDesign(.rounded)
            .bold()
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .font(.title2)
            .padding([.leading, .trailing])
            
            Spacer()
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
 
struct UnparkedView_Previews: PreviewProvider {
    static var previews: some View {
        UnparkedView()
    }
}
