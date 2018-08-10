//
//  Logger.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation

internal protocol Logger {
    
    func log(event: LoggingEvent)
}
