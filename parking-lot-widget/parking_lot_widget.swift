//
//  parking_lot_widget.swift
//  parking-lot-widget
//
//  Created by Taha Chaudhry on 17/08/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, vehicleModel: data.getVehicleModel(), parkingSpace: data.getParkingSpace(), isParked: data.getIsParked())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let vehicleModel: String
    let parkingSpace: String
    let isParked: Bool
}

struct parking_lot_widgetEntryView : View {
    var entry: Provider.Entry
    
    let data = DataService()
    //    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var vehicleModel: String = ""
    //    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var isParked: Bool = false
    //    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.parkinglot.pitch")) var parkingSpace: String = ""
    
    var body: some View {
        VStack {
            if !data.isParked {
                ZStack {
                    Color.black
                    VStack {
                        ForEach(1..<6) { row in
                            HStack(spacing: 10) {
                                ForEach(0..<5) { column in
                                    Button {
                                        
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor((row == 4) && (column == 3) ? Color.yellow : Color.black)
                                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.white, lineWidth: 1))
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .foregroundColor(Color.black)
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
                        }
                    }.padding(15)
                }
            } else {
                Text("\(data.vehicleModel) parked at \(data.parkingSpace)").onAppear {
                    print("test")
                }
            }
        }
    }
}

struct parking_lot_widget: Widget {
    let kind: String = "parking_lot_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            parking_lot_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct parking_lot_widget_Previews: PreviewProvider {
//    static var previews: some View {
//        parking_lot_widgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
