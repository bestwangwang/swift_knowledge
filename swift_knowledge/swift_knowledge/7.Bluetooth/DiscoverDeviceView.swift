//
//  DiscoverDeviceView.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/10.
//

import SwiftUI
import CoreBluetooth
import SwiftCommunity

struct DiscoverDeviceView: View {
    @ObservedObject
    var scanner = DeviceScanner()
    
    var body: some View {
        List {
            ForEach(scanner.devices) { device in
                VStack(alignment: .leading) {
                    Text(device.peripheral.name ?? "unkonwn")
                    Text("\(device.peripheral.state.rawValue)")
//                    Text(device.identifier.uuidString)
                    Text("\(device.advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "unkonwn")")
                }
            }
        }
    }
}

struct DiscoverDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverDeviceView()
    }
}


class DeviceScanner: ObservableObject {
    var manager = BluetoothManager()

    @Published
    var devices: [DiscoveredDevice] = []

    init() {
        manager.delegate = self
    }

    deinit {
        print("deinit")
    }
}

extension DeviceScanner: BluetoothManagerDelegate {

    func bluetoothManager(_ manager: BluetoothManager, didUpdateState state: CBManagerState) {

    }

    func bluetoothManager(_ manager: BluetoothManager, didUpdateDiscoveredDevices devices: [DiscoveredDevice]) {
        self.devices = devices
    }
}

extension DiscoveredDevice: Identifiable {
    public var id: UUID {
        self.identifier
    }
}
