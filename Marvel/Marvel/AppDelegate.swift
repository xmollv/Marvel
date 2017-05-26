//
//  AppDelegate.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataProvider: DataProvider!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create the one and only instance of dataProvider that must be passed to every class that needs it
        // I'm trying to mock dependency injection here by using an IUO on every view controller,
        // because we don't have dependency injection if we instantiate our view controllers from IB.
        dataProvider = DataProvider()
        
        // Create the window used for the entire app and apply a tint color
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.black
        
        // Instantiate our subclass of UITabBarController and establish it as the rootViewController
        let tabBar = TabBarViewController.instantiateFrom(storyboard: .TabBarViewController)
        tabBar.dataProvider = dataProvider
        window?.rootViewController = tabBar
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

