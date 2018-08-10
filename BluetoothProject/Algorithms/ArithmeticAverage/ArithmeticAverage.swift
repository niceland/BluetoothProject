//
//  ArithmeticAverage.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 08.06.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import UIKit

internal final class ArithmeticAverage {
    
    static func arithmeticAverageOf(measurements: [Double]) -> Double {
        let measurementsTotal = measurements.count
        guard measurementsTotal != 0 else { return 0 }
        var sum: Double = 0
        for measurement in measurements {
            sum += measurement
        }
        return sum/Double(measurementsTotal)
    }
}
