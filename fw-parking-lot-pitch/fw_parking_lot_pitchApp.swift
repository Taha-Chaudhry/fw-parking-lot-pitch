//
//  fw_parking_lot_pitchApp.swift
//  fw-parking-lot-pitch
//
//  Created by Taha Chaudhry on 16/08/2023.
//

import SwiftUI
import WidgetKit
import ActivityKit

@main
struct fw_parking_lot_pitchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage("vehicleModel", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var vehicleModel: String = ""
    @AppStorage("isParked", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isParked: Bool = false
    @AppStorage("parkingSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var parkingSpace: String = ""
    @AppStorage("isEVSpace", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isEVSpace: Bool = false
    @AppStorage("isCharging", store: UserDefaults(suiteName: "group.com.futureworkshops.widget.parking-lot")) var isCharging: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task {
            let center = UNUserNotificationCenter.current()
            let result = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
            guard result == true else {
                return print("Could not grant notification perms")
            }
            
            UIApplication.shared.registerForRemoteNotifications()
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let isParked = userInfo["isParked"] as? Bool {
            withAnimation {
                self.isParked = isParked
            }
            let content = UNMutableNotificationContent()
            let request: UNNotificationRequest
            
            if self.isParked == true {
                if parkingSpace != "" {
                    if let isEVSpace = userInfo["isEVSpace"] as? Bool, isEVSpace == true {
                        if let isCharging = userInfo["isCharging"] as? Bool {
                            switch (self.isCharging, isCharging) {
                            case (false, true):
                                content.title = "\(vehicleModel) now charging ⚡️"
                            case (true, false):
                                content.title = "\(vehicleModel) no longer charging"
                            default:
                                completionHandler(.noData)
                                return
                            }
                            
                            self.isEVSpace = isEVSpace
                            self.isCharging = isCharging
                            WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                            if Activity<ParkingAttributes>.activities.count != 0 {
                                UnparkedView().updateActivity(isCharging: isCharging)
                            } else {
                                content.body = "Tap to track at space \(self.parkingSpace)"
                                content.sound = UNNotificationSound.default
                                request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                                UNUserNotificationCenter.current().add(request)
                            }
                            completionHandler(.newData)
                        }
                    }
                    return
                }
                
                if let parkingSpace = userInfo["parkingSpace"] as? String {
                    self.parkingSpace = parkingSpace
                }
                
                if let isEVSpace = userInfo["isEVSpace"] as? Bool, let isCharging = userInfo["isCharging"] as? Bool {
//                    withAnimation {
                        self.isEVSpace = isEVSpace
                        self.isCharging = isCharging
//                    }
                }
                
                content.title = isEVSpace ? (isCharging ? "\(vehicleModel) parked and charging ⚡️" : "\(vehicleModel) parked") : "\(vehicleModel) parked"
                content.body = "Tap to track at space \(self.parkingSpace)"
                content.sound = UNNotificationSound.default
                
                WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request)
//                completionHandler(.newData)
            } else {
                ContentView().unpark()
                UnparkedView().stopActivity()
                
                content.title = "\(vehicleModel) unparked"
                content.body = "Thanks for using our service"
                content.sound = UNNotificationSound.default
                
                WidgetCenter.shared.reloadTimelines(ofKind: "parking_lot_widget")
                request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request)
                completionHandler(.newData)
            }
        }
    }
    
}
