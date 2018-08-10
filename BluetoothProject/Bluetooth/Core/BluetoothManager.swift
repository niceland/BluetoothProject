//
//  BluetoothManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 06.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BluetoothManager: NSObject, Bluetooth {
    
    internal enum DistanceFilteringMethod {
        case kalmanFilter, arithmeticAverage, weightedLinearAverage
    }
    
    private enum State {
        case inRange, outRange
    }
 
    private lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    
    private var kalmanFilter = KalmanFilter<Double>(stateEstimatePrior: 0.0, errorCovariancePrior: 1)
    
    private var entryHandler: (() -> ())?
    private var exitHandler: (() -> ())?
    private var distanceHandler: ((CLLocationAccuracy) -> ())?
    
    private var currentState = State.outRange {
        didSet {
            switch currentState {
            case .inRange:
                entryHandler?()
            case .outRange:
                exitHandler?()
            }
        }
    }
    
    private var exitScheduleTimer: Timer?
    
    private var distanceMeasurementsHistory = [Double]() {
        didSet {
            guard distanceMeasurementsHistory.count >= 10 else { return }
            _ = distanceMeasurementsHistory.dropFirst()
        }
    }
    
    private let expectedDeviceName: String
    private let distanceThreshold: Int
    private let exitTimeThreshold: TimeInterval
    private let distanceFilteringMethod: DistanceFilteringMethod
    
    init(expectedDeviceName: String, distanceThreshold: Int, exitTimeThreshold: TimeInterval, distanceFilteringMethod: DistanceFilteringMethod) {
        self.expectedDeviceName = expectedDeviceName
        self.distanceThreshold = distanceThreshold
        self.exitTimeThreshold = exitTimeThreshold
        self.distanceFilteringMethod = distanceFilteringMethod
    }
    
    func startObservation() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
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

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
        default:
            print("Initialiation of Bluetooth failed.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == expectedDeviceName {
            currentState = .inRange
            exitScheduleTimer?.invalidate()
            exitScheduleTimer = nil
            exitScheduleTimer = Timer(timeInterval: exitTimeThreshold, target: self, selector: #selector(scheduleExit), userInfo: nil, repeats: false)
            peripheral.delegate = self
            peripheral.readRSSI()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        guard error == nil else { return }
        handleRSSICalculation(rssi: RSSI.intValue)
    }
    
    @objc private func scheduleExit() {
        currentState = .outRange
    }
}

extension BluetoothManager {
    
    private func handleRSSICalculation(rssi: Int) {
        let distance = RSSIToDistance.calculateDistance(rssi: rssi, txPower: 1)
        distanceMeasurementsHistory.append(distance)
        guard
            distanceMeasurementsHistory.count > 4,
            let last = distanceMeasurementsHistory.last,
            let oneToLast = distanceMeasurementsHistory.oneToLast
        else {
            return
        }
        switch distanceFilteringMethod {
        case .arithmeticAverage:
            let average = ArithmeticAverage.arithmeticAverageOf(measurements: Array(distanceMeasurementsHistory.suffix(4)))
            distanceHandler?(CLLocationAccuracy(average))
        case .weightedLinearAverage:
            let average = WeightedLinearAverage.simpleMovingAverage(first: last, second: oneToLast, lambda: 0.8)
            distanceHandler?(CLLocationAccuracy(average))
        case .kalmanFilter:
            _ = kalmanFilter.predict(stateTransitionModel: 1, controlInputModel: 0, controlVector: 0, covarianceOfProcessNoise: 0)
            let update = kalmanFilter.update(measurement: last, observationModel: 1, covarienceOfObservationNoise: 0.1)
            kalmanFilter = update
            let average = kalmanFilter.stateEstimatePrior
            distanceHandler?(CLLocationAccuracy(average))
        }
    }
}
