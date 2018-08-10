//
//  File.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreLocation

internal struct BeaconParameters: Hashable, Equatable {
    
    let major: Int
    
    let minor: Int
    
    init(major: Int, minor: Int) {
        self.major = major
        self.minor = minor
    }
    
    init(beacon: CLBeacon) {
        major = beacon.major.intValue
        minor = beacon.minor.intValue
    }
    
    var hashValue: Int {
        return minor * major
    }
}
