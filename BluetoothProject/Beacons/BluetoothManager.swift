//
//  BluetoothManager.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 06.07.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, MeasurementsDelegate {
 
    var distance: Double?
    var centralManager: CBCentralManager!
    var estimotePeripheral: CBPeripheral!
    var timer: Timer?
    var isInExitMode: Bool = false
    var measurementsManager: MeasurementsManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        measurementsManager = MeasurementsManager(manager: self)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        
        if peripheral.name == "estimote" {
            estimotePeripheral = peripheral
            timer?.invalidate()
            distance = RSSIToDistance().calculateDistance(rssi:Int(truncating: RSSI), txPower: 1) //change txpower
            if isInExitMode {
                didEnter()
            }
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(didExit), userInfo: nil, repeats: true)
        }
    }
    
    @objc func didExit() {
        isInExitMode = true
        UserDefaults.standard.set(true, forKey: "DidExit from Core Bluetooth and it shouldn't be")
    }
    
    @objc func didEnter() {
        isInExitMode = false
        UserDefaults.standard.set(distance, forKey: "Distance from Core Bluetooth")
    }
    
    
}
