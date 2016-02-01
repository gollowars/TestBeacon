//
//  AppDelegate.swift
//  TestBeacon
//
//  Created by Yoshizumi Ashikawa on 2016/02/01.
//  Copyright © 2016年 Yoshizumi Ashikawa. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
	var mainView: ViewController!


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.makeKeyAndVisible()

    mainView = ViewController()
    self.window?.rootViewController = mainView

    return true
  }


}

