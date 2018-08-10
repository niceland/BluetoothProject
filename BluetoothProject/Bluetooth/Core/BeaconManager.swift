//
//  BeaconManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 01.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager: NSObject, Bluetooth {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        return locationManager
    }()
    
    private var entryHandler: (() -> ())?
    private var exitHandler: (() -> ())?
    private var distanceHandler: ((CLLocationAccuracy) -> ())?
    
    private let uuid: String
    private let expectedParameters: BeaconParameters
    
    init(uuid: String, expectedParameters: BeaconParameters) {
        self.uuid = uuid
        self.expectedParameters = expectedParameters
    }
    
    func startObservation() {
        guard let uuid = UUID(uuidString: self.uuid) else { return }
        let region = CLBeaconRegion(proximityUUID: uuid, major: UInt16(expectedParameters.major), minor: UInt16(expectedParameters.minor), identifier: "estimote")
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func stopObservation() {
        guard let region = locationManager.monitoredRegions.first else { return }
        locationManager.stopMonitoring(for: region)
    }
    
    func observeExit(_ handler: @escaping () -> ()) {
        exitHandler = handler
    }
    
    func observeEntry(_ handler: @escaping () -> ()) {
        entryHandler = handler
    }
    
    func observeDistance(_ handler: @escaping (CLLocationAccuracy) -> ()) {
        distanceHandler = handler
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let beacon = beacons.first else { return }
        distanceHandler?(beacon.accuracy)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        exitHandler?()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        entryHandler?()
    }
}
