//
//  File.swift
//  
//
//  Created by benwang on 2022/8/11.
//

import Foundation
import CoreBluetooth

public struct DiscoveredDevice {

    public var peripheral: CBPeripheral
    public var advertisementData: [String : Any]
    public var rssi: NSNumber

    public var identifier: UUID { peripheral.identifier }
    public var state: String { peripheral.state.text }
    public var name: String { peripheral.name ?? self.advLocalName ?? "null"}
    public var ancsAuthorized: Bool {
        if #available(iOS 13.0, *) {
            return peripheral.ancsAuthorized
        } else {
            return false
        }
    }
}

extension CBPeripheralState {
    var text: String {
        switch self {
        case .disconnected: return "disconnected"
        case .connecting: return "connecting"
        case .connected: return "connected"
        case .disconnecting: return "disconnecting"
        @unknown default:
            return "unknown"
        }
    }
}

public extension DiscoveredDevice {

    /**
     *  @constant CBAdvertisementDataLocalNameKey
     *
     *  @discussion A <code>NSString</code> containing the local name of a peripheral.
     *
     */
    var advLocalName: String? {
        advertisementData[CBAdvertisementDataLocalNameKey] as? String
    }

/**
 *  @constant CBAdvertisementDataTxPowerLevelKey
 *
 *  @discussion A <code>NSNumber</code> containing the transmit power of a peripheral.
 *
 */
    var advTxPowerLevel: NSNumber? {
        advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber
    }

/**
 *  @constant CBAdvertisementDataServiceUUIDsKey
 *
 *  @discussion A list of one or more <code>CBUUID</code> objects, representing <code>CBService</code> UUIDs.
 *
 */
    var advServiceUUIDs: [CBUUID] {
        advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
    }

/**
 *  @constant CBAdvertisementDataServiceDataKey
 *
 *  @discussion A dictionary containing service-specific advertisement data. Keys are <code>CBUUID</code> objects, representing
 *              <code>CBService</code> UUIDs. Values are <code>NSData</code> objects.
 *
 */
    var advServiceData: NSDictionary? {
        advertisementData[CBAdvertisementDataServiceDataKey] as? NSDictionary
    }

/**
 *  @constant CBAdvertisementDataManufacturerDataKey
 *
 *  @discussion A <code>NSData</code> object containing the manufacturer data of a peripheral.
 *
 */
    var advManufacturerData: String? {
        advertisementData[CBAdvertisementDataManufacturerDataKey] as? String
    }

/**
 *  @constant CBAdvertisementDataOverflowServiceUUIDsKey
 *
 *  @discussion A list of one or more <code>CBUUID</code> objects, representing <code>CBService</code> UUIDs that were
 *              found in the "overflow" area of the advertising data. Due to the nature of the data stored in this area,
 *              UUIDs listed here are "best effort" and may not always be accurate.
 *
 *  @see        startAdvertising:
 *
 */
    var advOverflowServiceUUIDs: [CBUUID] {
        advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID] ?? []
    }

/**
 *  @constant CBAdvertisementDataIsConnectable
 *
 *  @discussion An NSNumber (Boolean) indicating whether or not the advertising event type was connectable. This can be used to determine
 *                whether or not a peripheral is connectable in that instant.
 *
 */
    var advIsConnectable: Bool {
        (advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue ?? false
    }

/**
 *  @constant CBAdvertisementDataSolicitedServiceUUIDsKey
 *
 *  @discussion A list of one or more <code>CBUUID</code> objects, representing <code>CBService</code> UUIDs.
 *
 */
    var advSolicitedServiceUUIDs: [CBUUID] {
        advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] ?? []
    }

    var advTimestamp: NSNumber {
        advertisementData["kCBAdvDataTimestamp"] as? NSNumber ?? 0
    }

    var advRxPrimaryPHY: NSNumber {
        advertisementData["kCBAdvDataRxPrimaryPHY"] as? NSNumber ?? 0
    }

    var advRxSecondaryPHY: NSNumber {
        advertisementData["kCBAdvDataRxSecondaryPHY"] as? NSNumber ?? 0
    }
}
