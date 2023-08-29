//
//  parking_lot_widget.swift
//  parking-lot-widget
//
//  Created by Taha Chaudhry on 17/08/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked(), isCharging: data.getIsCharging(), isEVSpace: data.getIsEVSpace())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked(), isCharging: data.getIsCharging(), isEVSpace: data.getIsEVSpace())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked(), isCharging: data.getIsCharging(), isEVSpace: data.getIsEVSpace())
        entries.append(entry)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let vehicleModel: String
    let parkingSpace: String
    let isParked: Bool
    let isCharging: Bool
    let isEVSpace: Bool
}

struct parking_lot_widgetEntryView : View {
    var entry: Provider.Entry
    
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        if !entry.isParked {
            ZStack {
                Color.black
                VStack {
                    ForEach(1..<6) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<5) { column in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor((row == 4) && (column == 3) ? Color.yellow : Color.black)
                                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(.white, lineWidth: 1))
                                    if (row == 4) && (column == 3) {
                                        Image(systemName: "parkingsign")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }.padding(15)
            }
        } else {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        if entry.isEVSpace {
                            Label("Parking", systemImage: entry.isCharging ? "bolt.fill" : "bolt.slash")
                                .foregroundColor(entry.isCharging ? .green : .yellow)
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundColor(.yellow)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .top])
                        } else {
                            Text("Parking")
                                .foregroundColor(.yellow)
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundColor(.yellow)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .top])
                        }
                        HStack {
                            Text("\(entry.vehicleModel)")
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .foregroundColor(.black)
                                .bold()
                            DataService().getLogo(entry.vehicleModel)
                                .frame(width: 20, height: 20)
                        }.padding(.leading)
                    }
                }.padding([.top])
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                            Text("Since")
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        Text(formattedTime(from: entry.date))
                            .font(.title)
                    }.padding([.leading, .bottom])
                    Spacer()
                    ZStack {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        Text("\(entry.parkingSpace)")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontDesign(.rounded)
                    }.padding(.trailing)
                }
                Spacer()
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
                    Color.black.opacity(0.5),
                    lineWidth: 8
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.yellow,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

struct parking_lot_widget: Widget {
    let kind: String = "parking_lot_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            parking_lot_widgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Parking Lot Widget")
        .description("Shows open parking spaces and parked position")
    }
}

struct parking_lot_widget_Previews: PreviewProvider {
    static var previews: some View {
        parking_lot_widgetEntryView(entry: SimpleEntry(date: Date(), vehicleModel: "Toyota Yaris", parkingSpace: "A2", isParked: true, isCharging: false, isEVSpace: true))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
