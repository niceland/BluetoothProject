//
//  RSSIToDistance.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 08.06.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class RSSIToDistance {
    
    func calculateDistance(rssi: Int, txPower: Int) -> Double  {
        
        if rssi == 0 {
            return -1.0 // if accuracy cannot be determined
        }
        
        let ratio = Double(exactly: rssi)! / Double(txPower)
        
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return (0.89976) * pow(ratio, 7.7095) + 0.111
        }
    }
    
}
