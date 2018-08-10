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
            logString = "\(Date()), entry,\n"
        case .regionExit:
            logString = "\(Date()), exit,\n"
        case .distanceResult(let accuracy):
            logString = "\(Date()), \(accuracy),\n"
        }
        return logString.data(using: .utf8) ?? Data()
    }
}
