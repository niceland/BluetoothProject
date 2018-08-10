//
//  Array.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation

internal extension Array {
    
    var oneToLast: Element? {
        guard count >= 2 else { return nil }
        return self[count - 2]
    }
}
