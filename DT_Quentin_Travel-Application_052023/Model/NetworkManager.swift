//
//  NetworkManager.swift
//  DT_Quentin_Travel-Application_052023
//
//  Created by Quentin Dubut-Touroul on 24/06/2023.
//

import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()

    var isReachable: Bool {
        return monitor.currentPath.status == .satisfied
    }

    private init() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
