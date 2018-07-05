//
//  BeaconManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 01.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var enterHandler: (((Int?, Int?)) -> Void)?
    var exitHandler: (((Int?, Int?)) -> Void)?
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startSearchingForDeviceWithUUID(uuid: UUID) {
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: "myBeaconRegion")
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        var devices: [CLBeacon] = []
        
        for beacon in beacons {
            if beacon.proximity == CLProximity.immediate {
                devices.append(beacon)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let beaconRegion = CLBeaconRegion()
        
        if let handler = enterHandler {
            handler((beaconRegion.major?.intValue, beaconRegion.minor?.intValue))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let beaconRegion = CLBeaconRegion()
        
        if let handler = exitHandler {
            handler((beaconRegion.major?.intValue, beaconRegion.minor?.intValue))
        }
        
    }
}
