//
//  MeasurementsBaseViewController.swift
//  BluetoothProject
//
//  Created by Jan Posz on 10.08.2018.
//  Copyright © 2018 mpamula. All rights reserved.
//

import UIKit

internal final class MeasurementsBaseViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(bluetoothMonitoringButton)
        stackView.addArrangedSubview(beaconMonitoringButton)
        return stackView
    }()
    
    private var bluetoothMonitoringButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start bluetooth monitoring", for: .normal)
        return button
    }()
    
    private var beaconMonitoringButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start beacon monitoring", for: .normal)
        return button
    }()
    
    private var beaconMeasurements: MeasurementsManager?
    private var bluetoothMeasurements: MeasurementsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        let constraints = [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
        bluetoothMonitoringButton.addTarget(self, action: #selector(startBluetoothMonitoring), for: .touchUpInside)
        beaconMonitoringButton.addTarget(self, action: #selector(startBeaconMonitoring), for: .touchUpInside)
    }
    
    @objc private func startBluetoothMonitoring() {
        let type = MeasurementType.byBluetooth(deviceName: "estimote", distanceThreshold: 10, exitTimeThreshold: 5, filteringMethod: .kalmanFilter)
        let consoleLogHandler = {
            let logger = ConsoleLogger()
            self.startMeasurements(type: type, logger: logger)
        }
        let csvLogHandler = {
            let logger = CSVLogger(fileType: .bluetoothLogs)
            self.startMeasurements(type: type, logger: logger)
        }
        presentActionSheet(message: "Choose log format", buttons: [("Console", consoleLogHandler), ("CSV", csvLogHandler)])
    }
    
    @objc private func startBeaconMonitoring() {
        let type = MeasurementType.byBeacon(uuid: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", parameters: BeaconParameters(major: 44248, minor: 28219))
        let consoleLogHandler = {
            let logger = ConsoleLogger()
            self.startMeasurements(type: type, logger: logger)
        }
        let csvLogHandler = {
            let logger = CSVLogger(fileType: .beaconLogs)
            self.startMeasurements(type: type, logger: logger)
        }
        presentActionSheet(message: "Choose log format", buttons: [("Console", consoleLogHandler), ("CSV", csvLogHandler)])
    }
    
    private func startMeasurements(type: MeasurementType, logger: Logger) {
        let measurements = MeasurementsManager(type: type, logger: logger)
        switch type {
        case .byBeacon:
            beaconMeasurements = measurements
        case .byBluetooth:
            bluetoothMeasurements = measurements
        }
        measurements.startMeasurements()
    }
    
    private func presentActionSheet(message: String, buttons: [(String, () -> ())]) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        buttons.forEach { (title, closure) in
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                closure()
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}
