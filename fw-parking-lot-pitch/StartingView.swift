//
//  StartingView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import SwiftUI

struct StartingView: View {
    @State private var vehicleModel = ""
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var vehicleModelStorage: String = ""
    @AppStorage("name", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var name: String = ""
    @AppStorage("licensePlate", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var licensePlate: String = ""
    
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
                            Text("Profile")
                                .font(.largeTitle)
                                .bold()
                                .padding()
                            
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("Full Name")
                                        .fontDesign(.rounded)
                                        .bold()
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                    ZStack {
                                        VStack {
                                            TextField("John Doe...", text: $name)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(6)
                                                .shadow(radius: 3, x: 2, y: 2)
                                                .shadow(radius: 3, x: -2, y: -2)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing])
                                .padding([.leading, .trailing])
                                
                                VStack(alignment: .leading) {
                                    Text("Vehicle Model")
                                        .fontDesign(.rounded)
                                        .bold()
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                    ZStack {
                                        VStack {
                                            TextField("Toyota Camry...", text: $vehicleModel)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(6)
                                                .shadow(radius: 3, x: 2, y: 2)
                                                .shadow(radius: 3, x: -2, y: -2)
                                        }
                                        HStack {
                                            Spacer()
                                            DataService().getLogo(vehicleModel)
                                                .frame(width: 25, height: 25)
                                        }
                                        .padding(.trailing)
                                    }
                                }
                                .padding([.leading, .trailing, .top])
                                .padding([.leading, .trailing, .top])
                                
                                VStack(alignment: .leading) {
                                    Text("License plate")
                                        .fontDesign(.rounded)
                                        .bold()
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                    ZStack {
                                        VStack {
                                            TextField("BD51SMR...", text: $licensePlate)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(6)
                                                .shadow(radius: 3, x: 2, y: 2)
                                                .shadow(radius: 3, x: -2, y: -2)
                                        }
                                    }
                                }
                                .padding()
                                .padding()
                            }
                            
                            NavigationLink {
                                ContentView().navigationBarBackButtonHidden()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 300, height: 60)
                                        .foregroundColor(((name == "" || isBlank(name)) || (vehicleModel == "" || isBlank(vehicleModel)) || (licensePlate == "" || isBlank(licensePlate))) ? .gray : .black)
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
                            .disabled(((name == "" || isBlank(name)) || (vehicleModel == "" || isBlank(vehicleModel)) || (licensePlate == "" || isBlank(licensePlate))))
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



struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
