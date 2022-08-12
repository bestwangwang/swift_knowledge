//
//  File.swift
//  
//
//  Created by benwang on 2022/8/10.
//

import Foundation
import CoreBluetooth

@available(iOS 10.0, *)
public protocol BluetoothManagerDelegate: AnyObject {
    func bluetoothManager(_ manager: BluetoothManager, didUpdateState state: CBManagerState)
    func bluetoothManager(_ manager: BluetoothManager, didUpdateDiscoveredDevices devices: [DiscoveredDevice])
}

@available(iOS 10.0, *)
public class BluetoothManager: NSObject {
    
    var centralManager = CBCentralManager(delegate: nil, queue: nil)
    var peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)

    var peripherals: [UUID: DiscoveredDevice] = [:]

    public weak var delegate: BluetoothManagerDelegate?

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
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            centralManager.scanForPeripherals(withServices: bleDeviceServices, options: options)
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

        if let localName = peripheral.name {

//            guard let data = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data else { return }
//
//
//            let one = data.subdata(in: 0..<2)
//            let byte2 = data[2]
//
//            print(data)


            var abc = parsedNameAndPairingIdFrom(localName: localName)



        }

        if let service = peripheral.services?.first {
            peripheral.discoverCharacteristics(nil, for: service)
        }




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

let bleDeviceServices = [ CBUUID(string: "61353090-8231-49cc-b57a-886370740041"), CBUUID(string: "98ae7120-e62e-11e3-badd-0002a5d5c51b") ]

public func parsedNameAndPairingIdFrom(localName: String) -> (name: String, pairingId: String)? {
    do {
        // The local name for Suunto peripherals is comprised of the device model name
        // and unique identifier separated by whitespace, e.g., "Spartan SportWHR 016411300074".
        // #P is optional in front of the serial and marks for a prototype device, e.g., "Ambit3V #P1539195", # is excluded from the serial.
        let expression = try NSRegularExpression(pattern: "^(.+)\\s+[#]?([P]?[A-Z0-9]+)$", options: [])
        let trimmedLocalName = localName.trimmingCharacters(in: CharacterSet.whitespaces)

        if let match = expression.firstMatch(in: trimmedLocalName, options: [], range: trimmedLocalName.nsrange),
            let name = trimmedLocalName.substring(with: match.range(at: 1)),
            let identifier = trimmedLocalName.substring(with: match.range(at: 2)) {
            return (name, identifier)
        } else {
            return nil
        }
    } catch {
        return nil
    }
}

extension String {

    /// An `NSRange` representing the entire string.
    var nsrange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    /// Returns a substring for the given `NSRange` or `nil` if the range is invalid.
    ///
    /// - Parameter nsrange: A range representing the substring to return.
    /// - Returns: The substring between `nsrange.lowerBound` and `nsrange.upperBound`
    ///   or `nil` if the range falls outside this string.
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
    }

}

