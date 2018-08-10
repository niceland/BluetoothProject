//
//  MeasurementsManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 06.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

protocol MeasurementsDelegate {
    var distance: Double? { get }
    func didEnter()
    func didExit()
}

class MeasurementsManager: NSObject {
    
    var distance: Double?
    
    init(manager: MeasurementsDelegate) {
        super.init()
    }
}
