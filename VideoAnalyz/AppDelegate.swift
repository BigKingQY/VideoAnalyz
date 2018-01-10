//
//  AppDelegate.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/11/30.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 100, height: 80)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = (UIScreen.main.bounds.size.width - layout.itemSize.width * 3 - 20) / 3
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
        let navi = UINavigationController(rootViewController: HomeViewController())
        navi.navigationBar.barTintColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.darkGray

        self.window?.rootViewController = navi
        self.window?.makeKeyAndVisible()
        
        print("first version")
        
        print("哈哈")
        
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

