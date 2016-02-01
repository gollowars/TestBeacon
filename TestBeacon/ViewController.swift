//
//  ViewController.swift
//  TestBeacon
//
//  Created by Yoshizumi Ashikawa on 2016/02/01.
//  Copyright © 2016年 Yoshizumi Ashikawa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource {

  // Beacon
  var locationManager: CLLocationManager!
  var uuid: NSUUID!
  var beaconRegion: CLBeaconRegion?
  var beaconArray: NSMutableArray = ["null","null"]

  // Tabel
  var tableView: UITableView!


  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
		setupBeacon()
  }

  //pragma mark - UITableView
  internal func setupTableView(){
    print("setupTableView")
		tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    tableView.dataSource = self
    tableView.delegate = self
    self.view.addSubview(tableView)
  }

  override func viewDidAppear(animated: Bool) {

    
    if((locationManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
      if ((locationManager?.respondsToSelector("requestAlwaysAuthorization"))!) == false {
				locationManager?.requestAlwaysAuthorization()
      }else {
				locationManager.startRangingBeaconsInRegion(beaconRegion!)
      }

    }


  }

  override func viewDidDisappear(animated: Bool) {
    locationManager.stopRangingBeaconsInRegion(beaconRegion!)
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }

  // cellがクリックされた時の挙動
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

  }

  // tableViewのセクション数を指定
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  // cell数を指定
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beaconArray.count
  }

	// cellに値を設定
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
    let beacon:CLBeacon = beaconArray.objectAtIndex(indexPath.row) as! CLBeacon
    cell.textLabel!.text = beacon.proximityUUID.UUIDString
    return cell
  }


  //pragma mark - Location Manager
  internal func setupBeacon(){
    print("setupBeacon")
    uuid = NSUUID(UUIDString: "00000000-2992-1001-B000-001C4DC09044")
    beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: uuid.UUIDString)
    locationManager = CLLocationManager()
    locationManager.delegate = self
    beaconArray = NSMutableArray()

  }


  func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
    print("locate check")
    beaconArray.removeAllObjects()
    beaconArray.addObjectsFromArray(beacons)
		self.tableView.reloadData()
  }

  // 領域観測が開始した場合
  func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
    self.sendLocalNotificationForMessage("Start Monitoring Region")
  }

  // 領域に侵入した場合
  func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
    self.sendLocalNotificationForMessage("Enter Region")

    if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
      self.locationManager?.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
  }

  // 領域から退出した場合
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    self.sendLocalNotificationForMessage("Enter Region")

    if(region.isMemberOfClass(CLBeaconRegion) && CLLocationManager.isRangingAvailable()) {
      self.locationManager?.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
  }

  //pragma mark - push
  func sendLocalNotificationForMessage(message: NSString!) {
    let localNotification:UILocalNotification = UILocalNotification()
    localNotification.alertBody = message as String
    localNotification.fireDate = NSDate()
    localNotification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
  }


}

