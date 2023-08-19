//
//  UnparkedView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct UnparkedView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    @State private var activity: Activity<ParkingAttributes>? = nil
    @State private var isEditingVehicleModel = false
    
    var body: some View {
        VStack {
            Text("\($vehicleModel.wrappedValue)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Tap on the space you would like to park at")
                .fontDesign(.rounded)
                .bold()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
//                .padding()
            
            Divider()
            
            VStack {
                ForEach(0..<5) { row in
                    HStack {
                        let leftPreview = "\(Character(UnicodeScalar(row + 65)!))"
                        Text("").padding()
                        VStack {
                            if row == 0 {
                                Spacer()
                                    .frame(width: 40, height: 40)
                            }
                            Text("\(leftPreview)")
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .edgesIgnoringSafeArea(.bottom)
                        }
                        
                        ForEach(1..<5) { column in
                            ParkingGrid(isParked: isParked, parkingSpace: parkingSpace, activity: activity, row: row, column: column)
                        }.padding()
                        
                        Text("")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }.padding()
            }
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
                    isParked = false
                    parkingSpace = ""
                    WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                    $vehicleModel.wrappedValue = ""
                }) {
                    Label("Reset", systemImage: "exclamationmark.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $isEditingVehicleModel) {
            EditVehicleModelView(isEditing: $isEditingVehicleModel)
        }
        .sheet(isPresented: $isParked) {
            ParkedView(isParked: $isParked, activity: activity)
        }
    }
    
    func startActivity() {
        let activityAttributes = ParkingAttributes(vehicleModel: vehicleModel, parkingSpace: parkingSpace)
        let activityState = ParkingAttributes.ContentState(startDate: Date())

        let activityContent = ActivityContent(state: activityState, staleDate: nil)

        do {
            activity = try Activity<ParkingAttributes>.request(attributes: activityAttributes, content: activityContent)
        } catch(let error) {
            print("Eror starting activity: \(error)")
        }
    }
    
    func stopActivity() {
        let state = ParkingAttributes.ContentState(startDate: Date())

        let finalContent = ActivityContent(state: state, staleDate: nil)


        Task {
            for activity in Activity<ParkingAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
            }
        }
    }
}
