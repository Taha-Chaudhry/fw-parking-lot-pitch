//
//  parking_lot_widgetLiveActivity.swift
//  parking-lot-widget
//
//  Created by Taha Chaudhry on 17/08/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct parking_lot_widgetLiveActivity: Widget {
    let date = Date()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ParkingAttributes.self) { context in
            VStack() {
                HStack {
                    Text("Venue Parking Lot")
                        .fontDesign(.rounded)
                        .font(.title2)
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.black)
                        Text("\(context.attributes.parkingSpace)")
                            .foregroundColor(.yellow)
                            .font(.headline)
                            .fontDesign(.rounded)
                    }
                }
                
                HStack {
                    Text(date, style: .timer)
                        .font(.largeTitle)
                        .frame(width: 100)
                    
                    Spacer()
                    if context.state.isEVSpace {
                        Label("", systemImage: context.state.isCharging ? "bolt.fill" : "bolt.slash")
                            .foregroundColor(context.state.isCharging ? .green : .gray)
                    } else {
                        DataService().getLogo(context.attributes.vehicleModel)
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                    Link(destination: URL(string:"parkingapp://unpark")!) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 100, height: 40)
                                .foregroundColor(.black)
                            Text("Unpark")
                                .fontDesign(.rounded)
                                .fontWeight(.heavy)
                                .bold()
                                .foregroundColor(.white)
                        }.shadow(radius: 10)
                    }
                }
            }
            .activityBackgroundTint(Color.white)
            .activitySystemActionForegroundColor(Color.black)
            .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Parking")
                        .font(.title2)
                        .padding()
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.attributes.parkingSpace)")
                        .foregroundColor(.yellow)
                        .font(.headline)
                        .fontDesign(.rounded)
                        .padding([.top, .trailing])
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        HStack {
                            Text(date, style: .timer)
                                .font(.largeTitle)
                                .frame(width: 100)
                            
                            Spacer()
                            
                            if context.state.isEVSpace {
                                Label("", systemImage: context.state.isCharging ? "bolt.fill" : "bolt.slash")
                                    .foregroundColor(context.state.isCharging ? .green : .gray)
                            } else {
                                DataService().getLogo(context.attributes.vehicleModel)
                                    .frame(width: 30, height: 30)
                            }
                            Spacer()
                            
                            Link(destination: URL(string:"parkingapp://unpark")!) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 100, height: 40)
                                        .foregroundColor(.yellow)
                                    Text("Unpark")
                                        .fontDesign(.rounded)
                                        .fontWeight(.heavy)
                                        .bold()
                                        .foregroundColor(.black)
                                }.shadow(radius: 10)
                            }
                        }.padding([.bottom, .leading, .trailing])
                    }
                }
            } compactLeading: {
                Image(systemName: "parkingsign.circle")
                    .foregroundColor(.yellow)
            } compactTrailing: {
                Text("\(context.attributes.parkingSpace)")
            } minimal: {
                Image(systemName: "parkingsign.circle.fill")
                    .foregroundColor(.yellow)
                    .padding()
            }
        }
    }
}

struct parking_lot_widgetLiveActivity_Previews: PreviewProvider {
    static let attributes = ParkingAttributes(vehicleModel: "Toyota Yarris", parkingSpace: "A2")
    static let contentState = ParkingAttributes.ContentState(isEVSpace: false, isCharging: false)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
