//
//  AppDelegate.swift
//  ScalpApp
//
//  Created by GC Student on 11/2/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBigGIZkmd72Jpi8vd5gDEdz5xLoFfatcs")
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("qcbmSbOT8I4Dpxaqdb1D6A75xF8GLtuM4LqMf67b",
            clientKey: "nHcYz4TB3ufGQpWneCUMiy7DZ3r8qBlHBpfmiNlY")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 69.0/255.0, green: 104.0/255.0, blue: 231/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AmericanTypewriter-Bold", size: 20)!]
       // UITabBar.appearance().barTintColor = UIColor(red: 153.0/255.0, green: 194.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.blueColor()

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

