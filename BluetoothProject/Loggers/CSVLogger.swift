//
//  CSVLogger.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import Foundation

internal class CSVLogger: Logger {
    
    internal enum FileType {
        case bluetoothLogs, beaconLogs
        
        var filename: String {
            switch self {
            case .beaconLogs:
                return "beacon.csv"
            case .bluetoothLogs:
                return "bluetooth.csv"
            }
        }
    }
    
    internal var fileURL: URL? {
        let fileManager = FileManager.default
        let path = try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        return path?.appendingPathComponent(fileType.filename)
    }
    
    private let fileType: FileType
    
    init(fileType: FileType) {
        self.fileType = fileType
        createCSVFile(override: true)
    }
    
    func log(event: LoggingEvent) {
        guard let url = fileURL, let handle = FileHandle(forWritingAtPath: url.path) else { return }
        handle.seekToEndOfFile()
        handle.write(event.logData)
        handle.closeFile()
    }
    
    private func createCSVFile(override: Bool) {
        let fileManager = FileManager.default
        guard let url = fileURL else { return }
        if override {
            try? fileManager.removeItem(at: url)
        }
        fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
}
