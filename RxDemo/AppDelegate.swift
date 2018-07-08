//
//  AppDelegate.swift
//  RxDemo
//
//  Created by Aaron Musa on 01/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyB0HYj7g09ElFKR2gd0MgmHdoV0R64KBt8")
        GMSPlacesClient.provideAPIKey("AIzaSyB0HYj7g09ElFKR2gd0MgmHdoV0R64KBt8")
        return true
    }


}

