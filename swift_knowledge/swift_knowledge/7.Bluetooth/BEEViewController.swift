//
//  BEEViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/10.
//

import UIKit
import CoreBluetooth

class BEEViewController: UIViewController {

    lazy var centralManager = CBCentralManager(delegate: self, queue: nil)
    lazy var peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    var peripherals: [UUID: CBPeripheral] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        centralManager.delegate = self
//        peripheralManager.delegate = self




    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BEEViewController: CBCentralManagerDelegate {

    /// 当蓝牙状态发生改变时调用
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            fatalError()
        }
    }

    ///对于那些选择状态保存和恢复的应用程序，
    ///当你的应用程序重新启动到后台来完成一些蓝牙相关的任务时，这是第一个调用的方法。
    ///使用此方法同步您的应用程序的状态与蓝牙系统的状态。
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState: \(dict)")
    }

    /**
     *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
     *
     *  @param central              The central manager providing this update.
     *  @param peripheral           A <code>CBPeripheral</code> object.
     *  @param advertisementData    A dictionary containing any advertisement and scan response data.
     *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
     *                                was not available.
     *
     *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
     *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
     *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
     *
     *  @seealso                    CBAdvertisementData.h
     *
     */

    /*

     该方法在扫描时被<i>central</i>发现<i>peripheral</i>时调用。
     发现的外围设备必须为使用而保留;否则，它将被认为是无关紧要的，并由中央管理器进行清理。
     为一个<i>advertisementData</i> key的列表，参见{@link CBAdvertisementDataLocalNameKey}和其他类似的常量。

     RSSI: The Received Signal Strength Indicator (RSSI), in decibels, of the peripheral.
     外围设备的接收信号强度指示器(RSSI)，单位为分贝。
     */

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover: \ncentral: \(central)\nperipheral: \(peripheral)\nadvertisementData: \(advertisementData)\nrssi: \(RSSI)")

        peripherals[peripheral.identifier] = peripheral
    }

    /**
     *  @method centralManager:didConnectPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that has connected.
     *
     *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
     *
     */
    /// 当连接到外围设备时调用
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral)")
    }

    /**
     *  @method centralManager:didFailToConnectPeripheral:error:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
     *  @param error        The cause of the failure.
     *
     *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
     *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
     *
     */
    /// 当连接外围设备失败时调用，并提供报错信息
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
      print("didFailToConnect: \(peripheral) error: \(error)")
    }

    /**
     *  @method centralManager:didDisconnectPeripheral:error:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
     *  @param error        If an error occurred, the cause of the failure.
     *
     *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
     *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
     *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
     *
     */
    /// 当断开连接或断开连接失败时调用
    /*
     此方法在通过{@link connectPeripheral:options:}连接的外围设备断开连接时调用。如果断开
     *不是由{@link cancelPeripheralConnection}发起的，原因将在<i>error</i>参数中详细说明。一旦这种方法被采用
     *调用时，<i>peripheral</i>'s <code>CBPeripheralDelegate</code>将不再调用任何方法。
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral: \(peripheral) error: \(error)")
    }

    /**
     *  @method centralManager:connectionEventDidOccur:forPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param event        The <code>CBConnectionEvent</code> that has occurred.
     *  @param peripheral   The <code>CBPeripheral</code> that caused the event.
     *
     *  @discussion         This method is invoked upon the connection or disconnection of a peripheral that matches any of the options provided in {@link registerForConnectionEventsWithOptions:}.
     *
     */
    /*
     这个方法在外设连接或断开连接时被调用，该外设匹配{@link registerForConnectionEventsWithOptions:}中提供的任何选项。
     */
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("connectionEventDidOccur: \(event) peripheral: \(peripheral)")
    }


    /**
     *  @method centralManager:didUpdateANCSAuthorizationForPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that caused the event.
     *
     *  @discussion         This method is invoked when the authorization status changes for a peripheral connected with {@link connectPeripheral:} option {@link CBConnectPeripheralOptionRequiresANCS}.
     *
     */

    /*
     当与{@link connectPeripheral:}选项{@link CBConnectPeripheralOptionRequiresANCS}连接的外围设备的授权状态发生变化时，将调用此方法。
     */
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        print("didUpdateANCSAuthorizationFor: \(peripheral)")
    }
}

extension BEEViewController: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("外围设别：\(peripheral.state)")
    }

}
