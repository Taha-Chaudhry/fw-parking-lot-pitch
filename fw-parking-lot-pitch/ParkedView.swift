//
//  ParkedView.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 19/08/2023.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ParkedView: View {
    @Binding var isParked: Bool
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var parkingSpace: String = ""
    @AppStorage("isEVSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isEVSpace: Bool = false
    @AppStorage("isCharging", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isCharging: Bool = false
    
    @State private var progress: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var showText: Bool = false
    var activity: Activity<ParkingAttributes>?
    
    var body: some View {
        VStack {
            VStack {
                Text("Parking")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            ZStack {
                Image("ParkedImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 5, height: 190)
                        .foregroundColor(Color(red: 211/255, green: 211/255, blue: 211/255))
                    Spacer()
                    Spacer()
                }
                HStack {
                    Spacer()
                    Spacer()

                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 5, height: 190)
                        .foregroundColor(Color(red: 211/255, green: 211/255, blue: 211/255))
                    Spacer()
                }
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("\(String($parkingSpace.wrappedValue))")
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Spacer()
                }
                CircularProgressView(progress: progress)
                    .frame(width: 330, height: 330)
                    .padding()
            }.onAppear {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 15).speed(1.8).delay(0.175)) {
                    progress = 1
                }
                withAnimation(.easeInOut(duration: 1.5).delay(0.2)) {
                    showText = true
                }
            }.padding()
            
            Spacer()
            if showText {
                if isEVSpace {
                    Label("", systemImage: isCharging ? "bolt.fill" : "bolt.slash")
                        .foregroundColor(isCharging ? .green : .gray)
                        .scaleEffect(scale)
                        .onAppear {
                            if isCharging {
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    self.scale = 1.5
                                }
                            }
                        }
                }
                
                Text(isEVSpace ? (isCharging ? "Your car is charging and your parking is being tracked, you can close the app now." : "Your parking is being tracked, you can close the app now, or start charging.") : "Your parking is being tracked, you can close the app now.")
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
//            Spacer()
//
//            Button {
//                ContentView().unpark()
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 15)
//                        .frame(width: 300, height: 60)
//                        .foregroundColor(.black)
//                    Text("Unpark")
//                        .fontDesign(.rounded)
//                        .fontWeight(.heavy)
//                        .bold()
//                        .foregroundColor(.white)
//                }.shadow(radius: 10)
//            }
        }
        .interactiveDismissDisabled()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if Activity<ParkingAttributes>.activities.count == 0, isParked == true {
                do { try UnparkedView().startActivity() } catch {}
            }
        }
    }
}

private struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.yellow,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
