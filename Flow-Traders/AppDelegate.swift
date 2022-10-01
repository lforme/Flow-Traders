//
//  AppDelegate.swift
//  Flow-Traders
//
//  Created by DZSB-001968 on 30.9.22.
//

import UIKit
import SwiftDate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SwiftDate.defaultRegion = Region.current
        
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white  // solid color
        UIBarButtonItem.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.pixelFont(with: 20)]
        
        UITabBar.appearance().barTintColor = .black
        
        return true
    }


}

