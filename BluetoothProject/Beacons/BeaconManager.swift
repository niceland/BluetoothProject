//
//  BeaconManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 01.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconManager: NSObject, CLLocationManagerDelegate, MeasurementsDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var distance: Double?
    var devices: [CLBeacon] = []
    var estimoteBeacon: CLBeacon?
    var counter: Int = 0
    var rssiValueFromKalman: KalmanFilter<Double>?
    var rssiValueFromArithemticAverage: CGFloat?
    var measurementsManager: MeasurementsManager!
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        startSearchingForDeviceWithUUID(uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!)
        measurementsManager = MeasurementsManager(manager: self)
    }
    
    func startSearchingForDeviceWithUUID(uuid: UUID) {
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: "myBeaconRegion")
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beacon in beacons {
            if beacon.major == 44248 && beacon.minor == 28219 && counter < 101 {
                devices.append(beacon)
                counter = counter + 1
            } else if beacon.major == 44248 && beacon.minor == 28219 && counter > 100 {
                var measurements: [CGFloat] = []
                var filter = KalmanFilter(stateEstimatePrior: 0.0, errorCovariancePrior: 1)
                for estBeacon in devices {
                    measurements.append(CGFloat(estBeacon.rssi))
                    let prediction = filter.predict(stateTransitionModel: 1, controlInputModel: 0, controlVector: 0, covarianceOfProcessNoise: 0)
                    let update = prediction.update(measurement: Double(estBeacon.rssi), observationModel: 1, covarienceOfObservationNoise: 0.1)
                    filter = update
                }
                rssiValueFromKalman = filter
                rssiValueFromArithemticAverage = ArithmeticAverage().arithmeticAverageOf(measurements: measurements)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        estimoteBeacon = devices.first!
        
        for beacon in devices {
            if let estBeacon = estimoteBeacon, beacon.accuracy < estBeacon.accuracy {
                estimoteBeacon = beacon
                didEnter()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        didExit()
    }
    
    func didEnter() {
        distance = estimoteBeacon?.accuracy
        UserDefaults.standard.set(distance, forKey: "Distance from Core Location")
    }
    
    func didExit() {
        UserDefaults.standard.set(true, forKey: "DidExit from Core Location and it shouldn't be")
    }
    
    
}
