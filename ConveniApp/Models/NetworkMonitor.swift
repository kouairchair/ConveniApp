//
//  NetworkMonitor.swift
//  ConveniApp
//
//  Created by headspinnerd on 2021/07/09.
//  URL: https://medium.com/@udaykiran.munaga/swift-check-for-internet-connectivity-14e355fa10c5
//

import Foundation
import Network
import Logging

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                // TODO: post connected notification if needed
            } else {
                // TODO: post disconnected notification if needed
            }
            logger.debug("startMonitoring path.isExpensive:\(path.isExpensive)")
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
