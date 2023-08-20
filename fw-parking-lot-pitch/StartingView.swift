//
//  StartingView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import SwiftUI

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
                            
                            ZStack {
                                TextField("Toyota Camry...", text: $vehicleModel)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(6)
                                    .shadow(radius: 3, x: 2, y: 2)
                                    .shadow(radius: 3, x: -2, y: -2)
                                    .padding()
                                HStack {
                                    Spacer()
                                    DataService().getLogo(vehicleModel)
                                        .frame(width: 25, height: 25)
                                }
                                .padding(.trailing)
                                .padding(.trailing)
                            }
                            
                            NavigationLink {
                                ContentView().navigationBarBackButtonHidden()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 300, height: 60)
                                        .foregroundColor((vehicleModel == "" || isBlank(vehicleModel)) ? .gray : .black)
                                    Text("Next")
                                        .fontDesign(.rounded)
                                        .fontWeight(.heavy)
                                        .bold()
                                        .foregroundColor(.white)
                                }.shadow(radius: 10)
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                $vehicleModelStorage.wrappedValue = $vehicleModel.wrappedValue
                            })
                            .disabled(vehicleModel == "" || isBlank(vehicleModel))
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
