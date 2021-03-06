//
//  AppDelegate.swift
//  PinrPrototype
//
//  Created by Andres Arbelaez on 9/22/16.
//  Copyright © 2016 Andres Arbelaez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        GMSServices.provideAPIKey("AIzaSyBPeCF1K4c96MPv8x9JZHelnU6e_3Erlms")
        GMSPlacesClient.provideAPIKey("AIzaSyA5gkSc0WLr74E9VmIk6bUbv38FlbDhb24")
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "pinr"
                configuration.clientKey = "asdfasdfasdf"
                configuration.server = "https://stormy-coast-85212.herokuapp.com/parse"
            })
        )
        
        if PFUser.current() != nil {
            //do something to instantiate tab bar thing
        }
        
        
        FBSDKLoginButton.classForCoder()
        //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    /*
    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
*/
    
    func application(_ app: UIApplication, open url: URL, options: [String : AnyObject] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options["UIApplicationOpenURLOptionsSourceApplicationKey"] as! String, annotation: options["UIApplicationOpenURLOptionsAnnotationKey"])
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

