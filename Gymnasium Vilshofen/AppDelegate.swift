//
//  AppDelegate.swift
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 14.10.2014.
//  Copyright (c) 2014 4mayerhofers. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.applicationIconBadgeNumber = 0
        
        var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
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

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        var version = 1
        var hasLaunchedVersion = NSUserDefaults.standardUserDefaults().integerForKey("Version")
        
        if (version > hasLaunchedVersion) {
            println("version > hasLaunchedVersion")
            NSUserDefaults.standardUserDefaults().setObject(version, forKey: "Version")
        }else{
            var name = NSUserDefaults.standardUserDefaults().objectForKey("Name") as? String
            var klasse = NSUserDefaults.standardUserDefaults().objectForKey("Klasse") as? String
            
            var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
            var token: String = ( deviceToken.description as NSString ).stringByTrimmingCharactersInSet( characterSet ) as String
            var url1: String = "http://www.4mayerhofers.de/Push-GymVof/push/add/addDeviceToken.php?deviceToken="
            var url2: String = "&name="
            var url3: String = "&klasse="
            var url4: String = url1 + token + url2 + name! + url3 + klasse!
            var url5: String = ( url4 as NSString ).stringByReplacingOccurrencesOfString( " ", withString: "%20" ) as String
            let url = NSURL(string: url5)
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
            
            task.resume()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: NSDictionary!) {
        println("userInfo: \(userInfo)")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

