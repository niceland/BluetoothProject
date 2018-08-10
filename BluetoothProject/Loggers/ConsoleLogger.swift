//
//  ConsoleLogger.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation

internal class ConsoleLogger: Logger {
    
    func log(event: LoggingEvent) {
        switch event {
        case .regionEntry:
            print("Captured region entry")
        case .regionExit:
            print("Captured region exit.")
        case .distanceResult(let accuracy):
            print("Calculated distance: \(accuracy)")
        }
    }
}
