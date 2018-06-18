//
//  ArithmeticAverage.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 08.06.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import UIKit

class ArithmeticAverage {
    
    func arithmeticAverageOf(measurements: [CGFloat]) -> CGFloat {
        
        let measurementsTotal = measurements.count
        
        if measurementsTotal == 0 {
            return 0
        }
        
        var sum: CGFloat = 0
        
        for measurement in measurements {
            sum += measurement
        }
        
        return sum/CGFloat(measurementsTotal)
    }
}
