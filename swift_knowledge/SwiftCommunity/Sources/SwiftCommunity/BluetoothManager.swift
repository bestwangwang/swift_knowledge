//
//  File.swift
//  
//
//  Created by benwang on 2022/8/10.
//

import Foundation
import CoreBluetooth

public struct DiscoveredDevice {
    public var peripheral: CBPeripheral
    public var advertisementData: [String : Any]
    public var rssi: NSNumber

    public var identifier: UUID { peripheral.identifier }
}

@available(iOS 10.0, *)
public protocol BluetoothManagerDelegate {
    func bluetoothManager(_ manager: BluetoothManager, didUpdateState state: CBManagerState)
    func bluetoothManager(_ manager: BluetoothManager, didUpdateDiscoveredDevices devices: [DiscoveredDevice])
}

@available(iOS 10.0, *)
public class BluetoothManager: NSObject {
    
    var centralManager = CBCentralManager(delegate: nil, queue: nil)
    var peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)

    var peripherals: [UUID: DiscoveredDevice] = [:]

    public var delegate: BluetoothManagerDelegate?

    public override init() {
        super.init()
        centralManager.delegate = self
        peripheralManager.delegate = self
    }
}

@available(iOS 10.0, *)
extension BluetoothManager: CBCentralManagerDelegate {

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
//            let option =
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            fatalError()
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover: \ncentral: \(central)\nperipheral: \(peripheral)\nadvertisementData: \(advertisementData)\nrssi: \(RSSI)")

        peripherals[peripheral.identifier] = DiscoveredDevice(
            peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI
        )

        peripheral.delegate = self

        delegate?.bluetoothManager(self, didUpdateDiscoveredDevices: Array(peripherals.values))
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {

    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

    }

    public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {

    }

    public func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {

    }
}

@available(iOS 10.0, *)
extension BluetoothManager: CBPeripheralDelegate {

    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {

        if var device = peripherals[peripheral.identifier] {
            device.peripheral = peripheral
            peripherals[peripheral.identifier] = device
        }

        delegate?.bluetoothManager(self, didUpdateDiscoveredDevices: Array(peripherals.values))
    }
}

@available(iOS 10.0, *)
extension BluetoothManager: CBPeripheralManagerDelegate {

    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            fatalError()
        }
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {

    }

    public func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {

    }

    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {

    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {

    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {

    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {

    }
}
