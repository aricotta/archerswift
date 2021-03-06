//
//  AppDelegate.swift
//  archerswift
//
//  Created by Al Ricotta on 12/15/14.
//  Copyright (c) 2014 Al Ricotta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
        // add member to Firebase
        let ref = Firebase(url: "https://archerswift.firebaseio.com/v1/members")
        
        let idRef = ref.childByAutoId() //unique memberId
        idRef.setValue([
            "memberId":idRef.key,
            "fName":"Al",
            "lName":"Ricotta",
            "ssn":"123-45-6789",
            "dob":"1/1/22",
            "email":"al.ricotta@yahoo.com",
            "phone":"716-222-2222",
            "street1":"1234 Main Street",
            "street2":"Apt 22",
            "city":"Buffalo",
            "state":"NY",
            "zip":"14444",
            "sponsorId":"id1"
            ])
        */
        
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

