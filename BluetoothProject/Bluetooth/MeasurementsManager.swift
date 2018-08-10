//
//  MeasurementsManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 06.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation

internal enum MeasurementType {
    case byBluetooth(deviceName: String, distanceThreshold: Int, exitTimeThreshold: TimeInterval, filteringMethod: BluetoothManager.DistanceFilteringMethod)
    case byBeacon(uuid: String, parameters: BeaconParameters)
}

internal final class MeasurementsManager {
    
    private let bluetoothManager: Bluetooth
    private let logger: Logger
    
    init(type: MeasurementType, logger: Logger) {
        self.logger = logger
        switch type {
        case let .byBluetooth(deviceName: name, distanceThreshold: threshold, exitTimeThreshold: time, filteringMethod: method):
            bluetoothManager = BluetoothManager(expectedDeviceName: name, distanceThreshold: threshold, exitTimeThreshold: time, distanceFilteringMethod: method)
        case let .byBeacon(uuid: uuid, parameters: params):
            bluetoothManager = BeaconManager(uuid: uuid, expectedParameters: params)
        }
    }
    
    internal func startMeasurements() {
        bluetoothManager.startObservation()
        bluetoothManager.observeEntry { [weak self] in
            self?.handleEvent(event: .regionEntry)
        }
        bluetoothManager.observeExit { [weak self] in
            self?.handleEvent(event: .regionExit)
        }
        bluetoothManager.observeDistance { [weak self] distance in
            self?.handleEvent(event: .distanceResult(distance))
        }
    }
    
    private func handleEvent(event: LoggingEvent) {
        logger.log(event: event)
    }
}
