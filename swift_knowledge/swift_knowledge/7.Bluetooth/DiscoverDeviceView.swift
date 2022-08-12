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
                NavigationLink {
                    DeviceInfoView(device: device)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(device.name)
                            Spacer()
                            Text(device.rssi.stringValue )
                        }
                        HStack {
                            Text("\(device.state)")
                            Spacer()
                            Text("ancs:\(device.ancsAuthorized ? "1" : "0")")
                        }
                        Text("service：\(device.peripheral.services?.count ?? 0)")
                    }
                }
            }  
        }
    }
}

struct DeviceInfoView: View {
    var device: DiscoveredDevice
    var body: some View {
        VStack {
            Text(device.name)
            Text("\(device.advServiceDataKey.debugDescription)")

//            Text("\(device.advertisementData.debugDescription)")
            Spacer()
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
