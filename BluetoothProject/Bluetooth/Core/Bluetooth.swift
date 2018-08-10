//
//  Bluetooth.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreLocation

internal protocol Bluetooth {
    
    func startObservation()
    
    func observeEntry(_ handler: @escaping () -> ())
    
    func observeExit(_ handler: @escaping () -> ())
    
    func observeDistance(_ handler: @escaping (CLLocationAccuracy) -> ())
}
