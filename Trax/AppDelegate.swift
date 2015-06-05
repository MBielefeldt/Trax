//
//  AppDelegate.swift
//  Trax
//
//  Created by Mads Bielefeldt on 06/06/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

struct GPXURL {
    static let Notification = "GPXURL Radio Station"
    static let Key = "GPXURL URL Key"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        println("Url = \(url)")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.Key:url])
        notificationCenter.postNotification(notification)
        
        return true
    }
}
