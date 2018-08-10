//
//  LoggingEvent.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation
import CoreLocation

internal enum LoggingEvent {
    case regionEntry
    case regionExit
    case distanceResult(CLLocationAccuracy)
    
    var logData: Data {
        let logString: String
        switch self {
        case .regionEntry:
            logString = "\(Date()), entry"
        case .regionExit:
            logString = "\(Date()), exit"
        case .distanceResult(let accuracy):
            logString = "\(Date()), \(accuracy)"
        }
        return logString.data(using: .utf8) ?? Data()
    }
}
