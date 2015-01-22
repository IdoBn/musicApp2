//
//  AppDelegate.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 12/6/14.
//  Copyright (c) 2014 Ido Ben-Natan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        FBLoginView.self
        FBProfilePictureView.self
        
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        var wasHandedBool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandedBool
        
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
        println("foreground")
        NSNotificationCenter.defaultCenter().postNotificationName("UIApplicationWillEnterForegroundNotification", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("background")
        NSNotificationCenter.defaultCenter().postNotificationName("UIApplicationWillResignActiveNotification", object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // background
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        println("notification")
        NSNotificationCenter.defaultCenter().postNotificationName("RemoteControlEventReceived", object: event)
    }


}

