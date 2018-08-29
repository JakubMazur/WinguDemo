//
//  AppDelegate.swift
//  WinguDemo
//
//  Created by Jakub Mazur on 29/08/2018.
//  Copyright © 2018 wingu GmbH. All rights reserved.
//

import UIKit
import winguSDKEssential

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var winguLocations: WinguLocations = {
        let winguLocations = WinguLocations.shared
        winguLocations.apiKey = <# Your API KEY #>
        winguLocations.delegate = self
        winguLocations.beaconScanner.rediscoverNotificationTime = 0             // Set this to 0 if you want notification every time user pass channel (spamming avoiding time)
        winguLocations.beaconScanner.beaconFetchDataTime = 60                   // 60 seconds to hold cached data, if you want you may also trigger update(:) manually.
        winguLocations.returnOnlyChanelsWithContent = true                      // This will return only beacons with contents attached
        NotificationsManager.shared.shouldSendWinguNotifications = true         // If you've notifications enabled you will get wingu notifications.
        NotificationsManager.shared.onlyNotificationsWithContentUpdate = true   // Change it to false if you're interested in notification whenever content will update and user pass beacon next time
        return winguLocations
    }()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        winguLocations.useLaunchOptions(launchOptions)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        winguLocations.start()
        NotificationsManager.requestNotificationsPermission()
        return true
    }

}

extension AppDelegate: WinguLocationsDelegate {
    func winguChannels(_ channels: [Channel]) {
        UIApplication.shared.applicationIconBadgeNumber = channels.count
        for channel in channels {
            print(channel.content?.pack?.deck?.title ?? "-")
            print(channel.content?.lastChange ?? "-")
        }
    }
}
