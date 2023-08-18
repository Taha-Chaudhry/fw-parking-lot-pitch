//
//  ContentView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 16/08/2023.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    @State private var isEditingVehicleModel = false

    var body: some View {
        NavigationStack {
            VStack {
                if vehicleModel == "" {
                    StartingView()
                } else {
                    if isParked {
                        ParkedView()
                    } else {
                        withAnimation {
                            UnparkedView()
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: {
                                            isEditingVehicleModel.toggle()
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }.disabled(vehicleModel == "")
                                    }
                                }
                                .sheet(isPresented: $isEditingVehicleModel) {
                                    EditVehicleModelView(isEditing: $isEditingVehicleModel)
                                }
                        }
                    }
                }
            }
        }
    }
}

struct EditVehicleModelView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModelStorage: String = ""
    @Binding var isEditing: Bool
    
    @State private var vehicleModel: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Vehicle Model", text: $vehicleModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        $vehicleModelStorage.wrappedValue = $vehicleModel.wrappedValue
                        isEditing.toggle()
                    }) {
                        Text("Done")
                    }.disabled(vehicleModel == "")
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

struct StartingView: View {
    @State private var vehicleModel = ""
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModelStorage: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                
                Image("StartingImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 515)
                
                Spacer()
                
                Text("Venue Parking Lot")
                    .font(.largeTitle)
                    .bold()
                
                Text("Reserved parking spaces and easy ticket managing")
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink {
                    NavigationStack {
                        VStack {
                            Text("Vehicle Model")
                                .font(.largeTitle)
                                .bold()
                            
                            Text("This is used to track your vehicle and can be changed later")
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            
                            TextField("Toyota Camry...", text: $vehicleModel)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(6)
                                .shadow(radius: 3, x: 2, y: 2)
                                .shadow(radius: 3, x: -2, y: -2)
                                .padding()
                            
                            NavigationLink {
                                ContentView().navigationBarBackButtonHidden()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 300, height: 60)
                                        .foregroundColor(vehicleModel == "" ? .gray : .black)
                                    Text("Start Parking")
                                        .fontDesign(.rounded)
                                        .fontWeight(.heavy)
                                        .bold()
                                        .foregroundColor(.white)
                                }.shadow(radius: 10)
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                $vehicleModelStorage.wrappedValue = $vehicleModel.wrappedValue
                            })
                            .disabled(vehicleModel == "")
                        }
                        .navigationBarBackButtonHidden()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 300, height: 60)
                            .foregroundColor(.black)
                        Text("Get Started")
                            .fontDesign(.rounded)
                            .fontWeight(.heavy)
                            .bold()
                            .foregroundColor(.white)
                    }.shadow(radius: 10)
                }
            }
        }
    }
}

struct ParkedView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    var body: some View {
        Text("You are parked. Vehicle: \($vehicleModel.wrappedValue). Space: \($parkingSpace.wrappedValue)")
        Button("Unpark") {
            withAnimation {
                isParked = false
                parkingSpace = ""
                WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                // TODO: REMOVE THIS LINE
                $vehicleModel.wrappedValue = ""
            }
        }
    }
}

struct UnparkedView: View {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    var body: some View {
        VStack {
            Text("\($vehicleModel.wrappedValue)")
                .font(.largeTitle)
                .bold()
            
            Text("Tap on the space you would like to park at")
                .fontDesign(.rounded)
                .bold()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
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
                            ParkingGrid(isParked: isParked, parkingSpace: parkingSpace, row: row, column: column)
                        }.padding()
                        
                        Text("")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }.padding()
            }.padding()
        }
    }
}

struct ParkingGrid: View {
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
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
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
