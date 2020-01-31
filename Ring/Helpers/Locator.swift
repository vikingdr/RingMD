//
//  Location.swift
//  Ring
//
//  Created by RingMD on 31/10/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

import Foundation

import CoreLocation

private let locator = Locator()

class Locator: NSObject, CLLocationManagerDelegate {
  private var theLocationManager: CLLocationManager?
  
  private let geoCoder = CLGeocoder()
  
  private var country: String?
  
  private var subscribers: [String -> Void] = []
  
  class func sharedLocator() -> Locator {
    return locator
  }
  
  func obtainLocation(f: String -> Void) {
    subscribers.append(f)
    
    if country != nil {
      notifySubscribers()
      return
    }
    
    if theLocationManager == nil {
      let status = CLLocationManager.authorizationStatus()
      
      switch(status) {
      case .Restricted, .Denied:
        println("Not authorized to use the location manager")
      case .NotDetermined, .AuthorizedWhenInUse, .Authorized:
        let locationManager = CLLocationManager()
        theLocationManager = locationManager
        locationManager.delegate = self
        
        if status == CLAuthorizationStatus.NotDetermined {
          locationManager.requestWhenInUseAuthorization()
          println("Requested authorization to use the location manager")
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = kCLDistanceFilterNone
        let b = CLLocationManager.locationServicesEnabled()
        println("Enabled the location manager: \(b)")
      }
    }
    
    if let locationManager = theLocationManager {
      locationManager.startUpdatingLocation()
      println("Started the location manager")
    }
  }
  
  private func notifySubscribers() {
    assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
    
    for f in subscribers {
      f(country!)
    }
    
    subscribers = []
  }
  
  // MARK: CLLocationManagerDelegate
  
  func locationManager(manager: CLLocationManager!,
    didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      println("Locator authorization status changed: \(status.rawValue)")
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    for l in locations {
      let l = l as CLLocation
      if l.timestamp.timeIntervalSinceNow > -3600 {
        println("Looking up location name")
        geoCoder.reverseGeocodeLocation(l, completionHandler: { (placemarks: [AnyObject]!, err: NSError!) -> Void in
          if(err == nil) {
            let pm = placemarks.first as CLPlacemark
            println("Retrieved country name: \(pm.country)")
            self.country = pm.country
            self.notifySubscribers()
          } else {
            println("Failed to retrieve country name: \(err.localizedDescription)")
          }
        })
      } else {
        println("Skipping outdated location information")
      }
    }
    
    println("Did update locations: \(locations)")
    manager.stopUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    println("Failed to obtain a location: \(error)")
  }
}