//
//  WeightedLinearAverage.swift
//  BluetoothProject
//
//  Created by Magdalena Pamuła on 08.06.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import UIKit

internal final class WeightedLinearAverage {
    
    static func simpleMovingAverage(first: Double, second: Double, lambda: Double) -> Double {
        return (lambda * second + (1 - lambda) * first) / 3
    }
}
