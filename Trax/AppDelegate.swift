//
//  AppDelegate.swift
//  Trax
//
//  Created by Mads Bielefeldt on 06/06/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        println("Url = \(url)")
        return true
    }
}
